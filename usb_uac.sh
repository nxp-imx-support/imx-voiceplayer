#!/bin/bash

#To run this script use "./usb_uac.sh HEADPHONE"
#Initial script, it creates a usb gadget, it works well on nano,
#mini and 8ulp, the evk records an audio by usb and play it on the headphones.

# Check if an argument is passed
if [ $# -lt 1 ]; then
echo "Error: Missing sink parameter, usage $0 <SINK>"
exit 1
fi

#Sink parameter
sink=$1

# Create gadget
modprobe g_audio
echo "USB gadget successfully created";

# Start pulseaudio server
pulseaudio --start --log-target=syslog
echo "Pulseaudio server successfully started";

#Get EVK
evk=$(uname -n);
echo -e "EVK:${evk}";

if [[ $evk == "imx8ulpevk" ]]
then

        if [[ $sink == "HEADPHONE" ]]
        then
                #Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-imx-audio-rpmsg.0.auto.stereo-fallback>" | sed '$d' | cut -d " " -f 5);
                echo -e "SINK INDEX:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}
        else
                echo "Error: Invalid sink"
                exit 1
        fi

        #Get source pulse audio index
        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc.0.stereo-fallback>" | sed '$d' | cut -d " " -f 5);
        echo -e "SOURCE INDEX:${source_index}";

        # Set default source
        pacmd set-default-source ${source_index}

        # Loopback
        pactl load-module module-loopback
        echo "Loopback started";

elif  [[ $evk == "imx8mnevk" ]]
then
        if [[ $sink == "HEADPHONE" ]]
        then
                #Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524.stereo-fallback>" | sed '$d' | cut -d " " -f 6);
                echo -e "SINK INDEX:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}
        else
                echo "Error: Invalid sink"
                exit 1
        fi

        #Get source pulse audio index
        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc.0.stereo-fallback>" | sed '$d' | cut -d " " -f 5);
        echo -e "SOURCE INDEX:${source_index}";

        # Set default source
        pacmd set-default-source ${source_index}

        # Loopback
        pactl load-module module-loopback
        echo "Loopback started";

elif  [[ $evk == "imx8mmevk" ]]
then
        if [[ $sink == "HEADPHONE" ]]
        then
                #Get sink pulse audio index
                sink_index=$(pacmd list-sinks | grep -B1 "name: <alsa_output.platform-sound-wm8524.stereo-fallback>" | sed '$d' | cut -d " " -f 5);
                echo -e "SINK INDEX:${sink_index}";

                # Set default sink
                pacmd set-default-sink ${sink_index}
        else
                echo "Error: Invalid sink"
                exit 1
        fi

        #Get source pulse audio index
        source_index=$(pacmd list-sources | grep -B1 "name: <alsa_input.platform-ci_hdrc.0.stereo-fallback>" | sed '$d' | cut -d " " -f 5);
        echo -e "SOURCE INDEX:${source_index}";

        # Set default source
        pacmd set-default-source ${source_index}

        # Loopback
        pactl load-module module-loopback
        echo "Loopback started";

else
        echo "Unsupported EVK";
fi
