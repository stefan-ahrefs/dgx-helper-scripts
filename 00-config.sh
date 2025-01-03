#!/bin/bash

if [ "$(ls packages/*/*.fwpkg | wc -l)" != 2 ] ; then
	echo "Please run these scripts in the folder with firmware files" >&2
	exit 1
fi
FW1=$(pwd)/$(ls packages/*/*.fwpkg | rg -v _HGX_)
FW2=$(pwd)/$(ls packages/*/*_HGX_*.fwpkg)
echo "FW1=$FW1" >| config
echo "FW2=$FW2" >> config
echo "U=fill_here_BMC_user" >> config
echo "P=fill_here_BMC_password" >> config
echo "BMC_NETMASK=fill_here_BMC_netmask" >> config
echo "BMC_GW=fill_here_BMC_gateway" >> config
echo "Please fill the user name and password for accessing BMC of the DGX hosts in \"config\" file

# fill ipmi.txt with ipmi IPs of all dgx nodes
cmsh -c "device ; ls --category dgx-h100" | while read a b c ; do echo $b $(cmsh -c "device ; use $b ; interfaces ; get ipmi0 ip") ; done> ipmi.txt

