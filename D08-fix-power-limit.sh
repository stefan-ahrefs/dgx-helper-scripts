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

echo "Running curl -k -u \$U:\$P --request PATCH --location \"https://$ipmiip/redfish/v1/Chassis/HGX_Chassis_0/EnvironmentMetrics\" -H 'Content-Type: application/json' --data '{\"PowerLimitWatts\":{\"SetPoint\": 5600}}' | jq"
curl -k -u $U:$P --request PATCH --location "https://$ipmiip/redfish/v1/Chassis/HGX_Chassis_0/EnvironmentMetrics" -H 'Content-Type: application/json' --data '{"PowerLimitWatts":{"SetPoint": 5600}}' | jq

