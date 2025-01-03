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
echo "Estimated duration for upgrade 24 minutes. $(date -d 'now +  24 minutes')"
./nvfwupd --target ip=$ipmiip user=$U password=$P force_update enable
./nvfwupd --target ip=$ipmiip user=$U password=$P update_fw -p $FW1 -y -s bmc.json
./nvfwupd --target ip=$ipmiip user=$U password=$P force_update disable 
