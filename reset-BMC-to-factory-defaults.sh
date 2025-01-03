#!/bin/bash
exit 1
# fill variables with proper values then run this locally on the dgx host
IP_ADDR=
IP_MASK=
IP_GW=
BMC_USER=
BMC_PASS=

# first reset the BMC
ipmitool raw 0x32 0xBA 0x0 0x0
ipmitool raw 0x32 0x66

#reconfigure the basic settings of the BMC
ipmitool lan set 1 ipsrc static
ipmitool lan set 1 ipaddr $IP_ADDR
ipmitool lan set 1 netmask $IP_MASK
ipmitool lan set 1 defgw ipaddr $IP_GW
ipmitool user set name 4 $BMC_USER
ipmitool user set password 4 $BMC_PASS
ipmitool user priv 4 4 1
ipmitool user enable 4
ipmitool channel setaccess 1 4  callin=on ipmi=on link=on
