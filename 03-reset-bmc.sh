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
ipmitool -H $ipmiip -I lanplus -U $U -P $P mc reset cold
echo Waiting 30 seconds
sleep 30
echo "device ; shutdown $1" | cmsh 
