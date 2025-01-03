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
if [ "$2" = "" ] ; then
	task=1
else
	task=$2
fi

echo "Running: curl -k -u UUUU:XXXXX --request GET \"https://$ipmiip/redfish/v1/Managers/BMC/LogServices/SEL/Entries"
curl -k -u $U:$P --request GET "https://$ipmiip/redfish/v1/Managers/BMC/LogServices/SEL/Entries" | jq
