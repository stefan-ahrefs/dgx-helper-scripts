#!/bin/bash
pushd ~/DGX >/dev/null 2>&1
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
echo "Executing: ipmitool -I lanplus -H $ipmiip -U \$U -P \$P raw 0x3c 0x48 0x00 0xff 0x00 | head -1 | cut -f14- -d\  | ( read a b c d ; echo $b$a : $d$c )"
ipmitool -I lanplus -H $ipmiip -U $U -P $P raw 0x3c 0x48 0x00 0xff 0x00 | head -1 | cut -f14- -d\  | ( read a b c d ; echo $b$a : $d$c )
popd >/dev/null 2>&1
