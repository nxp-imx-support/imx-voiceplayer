#/bin/sh

# This script gets the MAC address. #
# A device needs to be connected for the script to work. #

# Get MAC address
MAC=$(bluetoothctl devices | cut -c 8-24);
echo "${MAC}" > /opt/Btplayer/bin/mac_address.txt
sed -i 's/:/_/g' /opt/Btplayer/bin/mac_address.txt
echo -e "MAC address:";
cat /opt/Btplayer/bin/mac_address.txt
