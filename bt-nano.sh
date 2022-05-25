#/bin/sh

#This script configures bluetooth and user can connect a device without
#user interactin on nano evk side
#Initial script, it only works on nano evk

pulseaudio --start --log-target=syslog
sleep 1
modprobe moal mod_para=nxp/wifi_mod_para.conf
sleep 5
hciattach /dev/ttymxc0 any 115200 flow
sleep 1
hciconfig hci0 up
hcitool -i hci0 cmd 0x3f 0x0009 0xc0 0xc6 0x2d 0x00
killall hciattach
hciattach /dev/ttymxc0 any -s 3000000 3000000 flow
sleep 1
hciconfig hci0 up
hciconfig hci0 sspmode 1
hciconfig hci0 piscan
hciconfig hci0 noauth
sdptool add SP
sleep 1

output="";
coproc bluetoothctl
read output <&${COPROC[0]}
echo "$output";
read output <&${COPROC[0]}
echo "$output";

read output <&${COPROC[0]}
echo "$output";
sleep 4
for (( c=1; c<11; c++ ))
do
echo -e 'yes\n' >&${COPROC[1]}
sleep .5
done
