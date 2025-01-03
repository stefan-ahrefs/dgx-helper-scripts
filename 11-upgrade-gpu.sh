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
echo "Estimated duration for upgrade 12 minutes. $(date -d 'now +  12 minutes')"
echo "Executing ./nvfwupd --target ip=$ipmiip user=\$U password=\$P update_fw -p $FW2 -y -s gpu_tray.json"
./nvfwupd --target ip=$ipmiip user=$U password=$P update_fw -p $FW2 -y -s gpu_tray.json
