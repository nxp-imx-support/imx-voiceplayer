#/bin/sh

# This script configures Bluetooth only one time. #

# Bluetooth function
Bluetooth () {
                # Init Bluetooth
                modprobe moal mod_para=nxp/wifi_mod_para.conf
                sleep 3
                hciattach /dev/tty$1 any 115200 flow
                sleep 1
                hciconfig hci0 up
                hcitool -i hci0 cmd 0x3f 0x0009 0xc0 0xc6 0x2d 0x00
                killall hciattach
                hciattach /dev/tty$1 any -s 3000000 3000000 flow
                sleep 1
                hciconfig hci0 up
                hciconfig hci0 sspmode 1
                hciconfig hci0 piscan
                hciconfig hci0 noauth
                sdptool add SP
                sleep 1

                # Automatic connection
                output="";
                coproc bluetoothctl
                for (( a=1; a<4; a++ ))
                do
                read output <&${COPROC[0]}
                echo "$output";
                done
                sleep 4
                for (( b=1; b<11; b++ ))
                do
                echo -e 'yes\n' >&${COPROC[1]}
                sleep .5
                done
}

# Check if Bluetooth was previously configured
bt_previous=$(hciconfig | grep hci0: | cut -c 1-5);

if [[ $bt_previous == "hci0:" ]]
then
echo -e "Bluetooth was previously configured";

else
# Get EVK name
evk=$(uname -n);
echo -e "Evk:${evk}";

        if  [[ $evk == "imx8ulp-lpddr4-evk" || $evk == "imx8ulpevk" ]]
        then
                # Bluetooth function
                Bluetooth LP2
        else
                # Bluetooth function
                Bluetooth mxc0
        fi
fi
