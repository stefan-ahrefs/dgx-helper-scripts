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

ssh -ntt $1 ' cp /cm/shared/fwupdate/fw-ConnectX7-rel-28_39_3560* . ; \
sudo mstflint -d /sys/bus/pci/devices/0000:5e:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:dc:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:c0:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:18:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:40:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:4f:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:ce:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:9a:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX750500B-0D00_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:aa:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX755206AS-NEA_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b ; \
sudo mstflint -d /sys/bus/pci/devices/0000:29:00.0/config -i fw-ConnectX7-rel-28_39_3560-MCX755206AS-NEA_Ax-UEFI-14.32.17-FlexBoot-3.7.300.signed.bin  b'

