#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                          
# SPDX-License-Identifier: BSD-3-Clause

# This script configures Bluetooth only one time

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

		echo "Auto connect..."
                while [ "$(ps -aux | grep Btplayer)" != "" ]
                do
                # Automatic connection
                output="";
                coproc bluetoothctl
                # pid of the command launched
                ID=$!
                echo "pid of the command launched:$ID";
                for (( a=1; a<4; a++ ))
                do
                read output <&${COPROC[0]}
                echo "$output";
                done
                sleep 4
                for (( b=1; b<7; b++ ))
                do
                echo -e 'yes\n' >&${COPROC[1]}
                sleep .3
                done
                kill ${ID}
                echo "Kill:$ID";

                # Check if Btplayer is running
                if [ "$(ps -aux | grep Btplayer)" == "" ]; then
                bluetoothctl disconnect
                exit 1
                fi

                # Get MAC address
                MAC=$(bluetoothctl info | grep Device | cut -c 8-24);
                echo "${MAC}" > /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                sed -i 's/:/_/g' /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                echo -e "MAC address:";
                cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                MAC=$(cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt);

                # Send the message notifying when a device has been connected
                /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/MsgQ 1${MAC}

                # Wait for disconnection
                output="";
                coproc bluetoothctl
                # pid of the command launched
                ID=$!
                echo "pid of the command launched:$ID";
                for (( a=1; a<4; a++ ))
                do
                read output <&${COPROC[0]}
                echo "$output";
                done
                # In this point a device has been disconnected #
                echo "Device has been disconnected";
                # Send the message notifying when a device has been disconnected
                /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/MsgQ 0${MAC}
                kill ${ID}
                echo "Kill:$ID";
		done

}

# Check if Bluetooth was previously configured
bt_previous=$(hciconfig | grep hci0: | cut -c 1-5);

if [[ $bt_previous == "hci0:" ]]
then

                while [ "$(ps -a | grep Btplayer)" != "" ]
                do
                # Automatic connection
                output="";
                coproc bluetoothctl
                # pid of the command launched
                ID=$!
                echo "pid of the command launched:$ID";
                for (( a=1; a<4; a++ ))
                do
                read output <&${COPROC[0]}
                echo "$output";
                done
                sleep 4
                for (( b=1; b<7; b++ ))
                do
                echo -e 'yes\n' >&${COPROC[1]}
                sleep .3
                done
                kill ${ID}
                echo "Kill:$ID";

                # Check if Btplayer is running
                if [ "$(ps -a | grep Btplayer)" == "" ]; then
                bluetoothctl disconnect
                exit 1
                fi

                # Get MAC address
                MAC=$(bluetoothctl info | grep Device | cut -c 8-24);
                echo "${MAC}" > /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                sed -i 's/:/_/g' /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                echo -e "MAC address:";
                cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                MAC=$(cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt);

                # Send the message notifying when a device has been connected
                /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/MsgQ 1${MAC}

                # Wait for disconnection
                output="";
                coproc bluetoothctl
                # pid of the command launched
                ID=$!
                echo "pid of the command launched:$ID";
                for (( a=1; a<4; a++ ))
                do
                read output <&${COPROC[0]}
                echo "$output";
                done
                # In this point a device has been disconnected #
                echo "Device has been disconnected";
                # Send the message notifying when a device has been disconnected
                /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/MsgQ 0${MAC}
                kill ${ID}
                echo "Kill:$ID";
                done

                # Get MAC address
                MAC=$(bluetoothctl devices | cut -c 8-24);
                echo "${MAC}" > /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                sed -i 's/:/_/g' /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                echo -e "MAC address:";
                cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt
                MAC=$(cat /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mac_address.txt);

                # Send the message notifying when a device has been connected
                /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/MsgQ 1${MAC}

else
# Get EVK name
evk=$(uname -n);
echo -e "Evk:${evk}";
rm device.txt
echo evk > device.txt;

# Start pulseaudio server
pulseaudio --start --log-target=syslog
echo "Pulseaudio server successfully started";
   # Get card number
                alsa_sink=$(aplay -l | grep -B1 "Loopback" | grep -B1 "1" | cut -c 6-6 | sed '1d');
                #alsa_sink=$(aplay -l | grep -B1 "btscoaudio" | grep -B1 "0" | cut -c 6-6 | sed '1d');
                echo -e "Loopback card:${alsa_sink}";
  
               # Load the pulseaudio module
                pacmd load-module module-alsa-sink device=hw:${alsa_sink},1

  
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.hw*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.hw*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Sink index:${sink_index}";
   
                # Set default sink
                # pacmd set-default-sink ${sink_index}
                pacmd set-default-sink 
  
                # Get source pulse audio index
                source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-sound-bt*" | sed '$d' | cut -d " " -f 5);
                if  [[ $source_index == "" || $source_index == "index:" ]]
                then
                        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-sound-bt*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Source index:${source_index}";

                   # Set default source
                pacmd set-default-source ${source_index}
	
        if  [[ $evk == "imx8ulp-lpddr4-evk" || $evk == "imx8ulpevk" ]]
        then
		# Bluetooth function
		Bluetooth LP2

	else
                # Bluetooth function
                Bluetooth mxc0
        fi
fi
