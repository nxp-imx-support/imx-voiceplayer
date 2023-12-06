#!/bin/bash

# Copyright 2022-2023 NXP                                                                                                              
# SPDX-License-Identifier: BSD-3-Clause

# This script configures Bluetooth only one time

# Bluetooth function
Bluetooth () {
        /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/stop.sh &
        # Init Bluetooth
        modprobe moal mod_para=nxp/wifi_mod_para.conf
        sleep 3
        modprobe btnxpuart
        hciconfig hci0 up
        sleep 1
        #Set Baud Rate to 3000000
        #hcitool -i hci0 cmd 0x3f 0x0009 0xc0 0xc6 0x2d 0x00
        sleep 2
        sleep 1
        hciconfig hci0 up
        #SSP(Simple secure pairing) : New way to create linkkey using simple secure pairing
        hciconfig hci0 sspmode 1
        hciconfig hci0 piscan
        #Disable authentication
        hciconfig hci0 noauth
        echo "no auth"
        sdptool add SP
        sleep 1
        bluetoothctl discoverable off
        bluetoothctl pairable off
        sleep 1
        bluetoothctl reset-alias
        bluetoothctl system-alias iMX-MultimediaPlayer
        bluetoothctl discoverable on
        sleep 1
        bluetoothctl pairable on
        sleep 1
        bluetoothctl show
        echo "Auto connect..."
        while [ "$(ps -aux | grep VoicePlayer)" != "" ]
        do
                # Automatic connection
                output="";
                coproc bluetoothctl
                ID=$!
                echo "pid of the command launched:$ID";
                #Time delay for the User responce, Accept Pair Code
                for (( a=1; a<4; a++ ))
                do
                        read output <&${COPROC[0]}
                        echo "$output";
                done
                sleep 4
                #Yes command to accept Pair code and Authorize Service
                for (( b=1; b<11; b++ ))
                do
                        echo -e 'yes\n' >&${COPROC[1]}
                        sleep .3
                done
                #Exit from the Bluetoothctl
                echo -e 'exit\n' >&${COPROC[1]}
                kill ${ID}
                echo "Kill:$ID";

                # Check if VoicePlayer is running
                if [ "$(ps -aux | grep VoicePlayer)" == "" ]; then
                        bluetoothctl disconnect
                        exit 1
                fi

                # Get MAC address
                MAC=$(bluetoothctl info | grep Device | cut -c 8-24);
                echo "${MAC}" > /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                sed -i 's/:/_/g' /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                echo -e "MAC address:";
                cat /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                MAC=$(cat /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt);

                # Send the message notifying when a device has been connected
                /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/MsgQ 1${MAC}

                # Check if Bluetooth is connected
                bt_status=$(bluetoothctl devices Connected);
                echo -e "Bluetooth Status:${bt_status}";
                while [ "${bt_status}" != "" ]
                do
                        sleep .5
                        bt_status=$(bluetoothctl devices Connected);
                done

                # In this point a device has been disconnected #
                echo "Device has been disconnected";
                # Send the message notifying when a device has been disconnected
                /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/MsgQ 0${MAC}
       done

}

# Set Audio function
Set_Audio () {

        # Start pulseaudio server
        pulseaudio --start --log-target=syslog
        echo "Pulseaudio server successfully started";
        # Get card number
        alsa_sink=$(aplay -l | grep -B1 "Loopback" | grep -B1 "1" | cut -c 6-6 | sed '1d');
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
        pacmd set-default-sink ${sink_index}

        # Get source pulse audio index
        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-sound-bt*" | sed '$d' | cut -d " " -f 5);
        if  [[ $source_index == "" || $source_index == "index:" ]]
        then
                source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-sound-bt*" | sed '$d' | cut -d " " -f 6);
        fi
        echo -e "Source index:${source_index}";

        # Set default source
        pacmd set-default-source ${source_index}
}

# Check if Bluetooth was previously configured
bt_previous=$(hciconfig | grep hci0: | cut -c 1-5);

if [[ $bt_previous == "hci0:" ]]
then
        /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/stop.sh &
        #Disconnect from any device
        #bluetoothctl disconnect
        bluetoothctl discoverable off
        bluetoothctl pairable off
        sleep 1
        bluetoothctl discoverable on
        sleep 1
        bluetoothctl pairable on
        sleep 1
        bluetoothctl show
        echo "Auto connect..."
        while [ "$(ps -aux | grep VoicePlayer)" != "" ]
        do
                # Automatic connection
                output="";
                coproc bluetoothctl
                ID=$!
                echo "pid of the command launched:$ID";
                #Time delay for the User responce, Accept Pair Code
                for (( a=1; a<4; a++ ))
                do
                        read output <&${COPROC[0]}
                        echo "$output";
                done
                sleep 4
                #Yes command to accept Pair code and Authorize Service
                for (( b=1; b<11; b++ ))
                do
                        echo -e 'yes\n' >&${COPROC[1]}
                        sleep .3
                done
                #Exit from the Bluetoothctl
                echo -e 'exit\n' >&${COPROC[1]}
                kill ${ID}
                echo "Kill:$ID";

                # Check if VoicePlayer is running
                if [ "$(ps -aux | grep VoicePlayer)" == "" ]; then
                        bluetoothctl disconnect
                        exit 1
                fi
                # Get MAC address
                MAC=$(bluetoothctl info | grep Device | cut -c 8-24);
                echo "${MAC}" > /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                sed -i 's/:/_/g' /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                echo -e "MAC address:";
                cat /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt
                MAC=$(cat /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mac_address.txt);

                # Send the message notifying when a device has been connected
                /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/MsgQ 1${MAC}

                # Check if Bluetooth is connected
                bt_status=$(bluetoothctl devices Connected);
                echo -e "Bluetooth Status:${bt_status}";
                while [ "${bt_status}" != "" ]
                do
                        sleep .5
                        bt_status=$(bluetoothctl devices Connected);
                done

                # In this point a device has been disconnected #
                echo "Device has been disconnected";
                # Send the message notifying when a device has been disconnected
                /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/MsgQ 0${MAC}
        done
else
        # Get EVK name
        sync
        evk=$(uname -n);
        echo -e "Evk:${evk}";
        rm device.txt
        echo evk > device.txt;

        # Set Audio
        Set_Audio
   
       if  [[ $evk == "imx93-11x11-lpddr4x-evk" || $evk == "imx93evk" ]]
        then
                # Bluetooth function
                Bluetooth LP4
        else
                # Bluetooth function
                Bluetooth mxc0
        fi
fi
