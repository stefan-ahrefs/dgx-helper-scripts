#!/bin/bash
if [ ! -f config ] ; then
	echo "Please run 00-config.sh first" >&2
	exit 1
fi
. config
if [ "$1" = "" ] ; then
	echo "Usage: $0 <BMC ip>" >&2
	exit 1
fi
ipmiip=$(grep "$1" ipmi.txt | head -1 | cut -f1 -d\ )
if [ "$ipmiip" = "" ] ; then
	echo "$0 error: $1 not identified as host" >&2
	exit 1
fi
ssh -ntt $1 "ipmitool lan set 1 ipsrc static ; ipmitool lan set 1 ipaddr $ipmiip ; ipmitool lan set 1 netmask $BMC_NETMASK ; ipmitool lan set 1 defgw ipaddr $BMC_GW; ipmitool lan print ; ipmitool user set name 4 $U ; ipmitool user set password 4 $P ; ipmitool user priv 4 4 1 ; ipmitool user enable 4 ; ipmitool channel setaccess 1 4  callin=on ipmi=on link=on ; ipmitool user list 1"
