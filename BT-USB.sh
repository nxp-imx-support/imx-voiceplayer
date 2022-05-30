#/bin/sh

# This script configures Bluetooth or USB as audio source,         #
# user can connect a device without interaction on i.MX8 evk side, #
# also it sets the audio output in the 3.5mm Jack.                 #
# Usage: ./BT-USB.sh Bluetooth  Set Bluetooth audio source           #
# Usage: ./BT-USB.sh USB        Set USB audio source                 #

# Check if an argument is passed
if [ $# -lt 1 ]; then
echo "Error: Missing source parameter, usage $0 <SOURCE>", available sources: Bluetooth or USB
exit 1
fi

# Bluetooth or USB source parameter
source=$1

# Check if the argument is correct
if  [[ $source == "Bluetooth" || $source == "USB" ]]
then
echo -e "Source:${source}";
else
echo "Error: Source parameter is incorrect, available sources: Bluetooth or USB"
exit 1
fi

# Start pulseaudio server
pulseaudio --start --log-target=syslog
echo "Pulseaudio server successfully started";

# Get EVK name
evk=$(uname -n);
echo -e "Evk:${evk}";

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

if [[ $source == "Bluetooth" ]]
then
        if  [[ $evk == "imx8mnevk" || $evk == "imx8mmevk" || $evk == "imx8mm-lpddr4-evk" ]]
        then
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524*" | sed '$d' | cut -d " " -f 6);
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

		# Bluetooth function
		Bluetooth mxc0

        elif  [[ $evk == "imx8mpevk" ]]
        then
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8960*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8960*" | sed '$d' | cut -d " " -f 6);
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

		# Bluetooth function
		Bluetooth mxc0

        elif  [[ $evk == "imx8ulp-lpddr4-evk" || $evk == "imx8ulpevk" ]]
        then
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-imx-audio-rpmsg*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-imx-audio-rpmsg*" | sed '$d' | cut -d " " -f 6);
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

		# Bluetooth function
		Bluetooth LP2

	else
        echo "Unsupported EVK";

        fi

else
	# Create gadget
	modprobe g_audio
	echo "USB gadget successfully created";

        if  [[ $evk == "imx8mnevk" || $evk == "imx8mmevk" || $evk == "imx8mm-lpddr4-evk" ]]
        then   
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Sink index:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}

                # Get source pulse audio index
                source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc*" | sed '$d' | cut -d " " -f 5);
                if  [[ $source_index == "" || $source_index == "index:" ]]
                then
                        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Source index:${source_index}";

                # Set default source
                pacmd set-default-source ${source_index} 

	        # Loopback
 	        pactl load-module module-loopback
        	echo "Loopback started";    

        elif  [[ $evk == "imx8ulp-lpddr4-evk" || $evk == "imx8ulpevk" ]]
        then
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-imx-audio-rpmsg*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-imx-audio-rpmsg*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Sink index:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}

                # Get source pulse audio index
                source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc*" | sed '$d' | cut -d " " -f 5);
                if  [[ $source_index == "" || $source_index == "index:" ]]
                then
                        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Source index:${source_index}";

                # Set default source
                pacmd set-default-source ${source_index}

	        # Loopback
	        pactl load-module module-loopback
	        echo "Loopback started";

        elif  [[ $evk == "imx8mpevk" ]]
        then
                # Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8960*" | sed '$d' | cut -d " " -f 5);
                if  [[ $sink_index == "" || $sink_index == "index:" ]]
                then
                        sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8960*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Sink index:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}

                # Get source pulse audio index
                source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-38100000*" | sed '$d' | cut -d " " -f 5);
                if  [[ $source_index == "" || $source_index == "index:" ]]
                then
                        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-38100000*" | sed '$d' | cut -d " " -f 6);
                fi
                echo -e "Source index:${source_index}";

                # Set default source
                pacmd set-default-source ${source_index}

	        # Loopback
	        pactl load-module module-loopback
	        echo "Loopback started";
	else
        echo "Unsupported EVK";

	fi
fi
