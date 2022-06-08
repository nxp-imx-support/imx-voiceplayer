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

# Start pulseaudio server
pulseaudio --start --log-target=syslog
echo "Pulseaudio server successfully started";

        if  [[ $evk == "imx8mnevk" || $evk == "imx8mmevk" || $evk == "imx8mm-lpddr4-evk" || $evk == "imx8mm-ddr4-evk" || $evk == "imx8mn-lpddr4-evk" || $evk == "imx8mn-ddr4-evk" ]]
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

        elif  [[ $evk == "imx8mpevk" || $evk == "imx8mp-ddr4-evk" || $evk == "imx8mp-lpddr4-evk" ]]
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
fi
