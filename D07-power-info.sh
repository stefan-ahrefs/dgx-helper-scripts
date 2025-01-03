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
#ipmitool -I lanplus -H $ipmiip -U $U -P $P raw 0x3c 0x48 0x00 0xff 0x00 | head -1 | cut -f14- -d\  | ( read a b c d ; echo $b$a : $d$c )

DUMPFILE=/cm/shared/dumps/$(date +%Y%m%d)-$1-powerinfo.txt
echo dumping output to $DUMPFILE
exec >| $DUMPFILE
echo "1. ipmitool raw 0x3c 0x80 0x05  (to get any power limit set in BMC - run from host)"
ssh $1 ipmitool raw 0x3c 0x80 0x05
echo 2.  Get the current limit set in GPUs.
echo "    curl -k -u username:passwd --request GET --location 'https://<BMC-IP>/redfish/v1/Systems/HGX_Baseboard_0/Processors/GPU_SXM_1/EnvironmentMetrics' | jq"
    curl -k -u $U:$P --request GET --location "https://$ipmiip/redfish/v1/Systems/HGX_Baseboard_0/Processors/GPU_SXM_1/EnvironmentMetrics" | jq
echo "    curl -k -u username:passwd --request GET --location 'https://<BMC-IP>/redfish/v1/Systems/HGX_Baseboard_0/Processors/GPU_SXM_1/EnvironmentMetrics' | jq"
    curl -k -u $U:$P --request GET --location "https://$ipmiip/redfish/v1/Systems/HGX_Baseboard_0/Processors/GPU_SXM_1/EnvironmentMetrics" | jq
echo "3. Get Chassis level limit:"
echo "     curl -k -u username:passwd --request GET --location 'https://<BMC-IP>/redfish/v1/Chassis/HGX_Chassis_0/EnvironmentMetrics"
     curl -k -u $U:$P --request GET --location "https://$ipmiip/redfish/v1/Chassis/HGX_Chassis_0/EnvironmentMetrics" | jq
echo 4. BMC noder manager policies, if any
echo "    curl  -k -u <bmcusername>:<password>  https://<bmcip>/redfish/v1/Managers/BMC/NodeManager"
    curl  -k -u $U:$P https://$ipmiip/redfish/v1/Managers/BMC/NodeManager | jq
echo "    curl  -k -u <bmcusername>:<password> https://<bmcip>/redfish/v1/Managers/BMC/NodeManager/Domains"
    curl  -k -u $U:$P https://$ipmiip/redfish/v1/Managers/BMC/NodeManager/Domains | jq
