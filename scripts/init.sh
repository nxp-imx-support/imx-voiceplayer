#!/bin/bash

# Copyright 2022-2023 NXP
# SPDX-License-Identifier: BSD-3-Clause

rm /dev/mqueue/voice_ui_queue

uname -n > /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/device.txt
evk=$(uname -n);

echo -e "Evk:${evk}";
cp -v /etc/asound.conf /etc/asound.conf_original

if  [[ $evk == "imx8mp-lpddr4-evk" || $evk == "imx8mpevk" ]]
then
        cp -v /unit_tests/nxp-afe/asound.conf_imx8mp /etc/asound.conf
elif [[ $evk == "imx93-11x11-lpddr4x-evk" || $evk == "imx93evk" ]]
then
        cp -v /unit_tests/nxp-afe/asound.conf_imx93 /etc/asound.conf
elif  [[ $evk == "imx8mm-lpddr4-evk" || $evk == "imx8mmevk" ]]
then
        cp -v /unit_tests/nxp-afe/asound.conf_imx8mm /etc/asound.conf
else
        cp -v /unit_tests/nxp-afe/asound.conf /etc/asound.conf
fi

modprobe snd-aloop

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/Config.ini /unit_tests/nxp-afe
touch /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/mute.vol
cp /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/WakeWordNotify /usr/bin/
cp /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/WWCommandNotify /usr/bin/


if [ -d "/usr/lib/python3.11/site-packages/posix_ipc*" ]
then
        echo Installing posix_ipc...
        python3 -m pip install --upgrade posix_ipc --trusted-host pypi.org --trusted-host files.pythonhosted.org
        sleep 3s
else
	echo ""
	echo "posix_ipc is already installed"
fi

killall voice_ui_app
killall afe
killall btp
killall VoicePlayer

sleep 0.1s


if [[ $evk == "imx93-11x11-lpddr4x-evk" || $evk == "imx93evk" ]]
then
        /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/i.MX9X_A55/voice_ui_app -notify &
else
        /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/i.MX8M_A53/voice_ui_app -notify &
fi

sleep 1
/unit_tests/nxp-afe/afe libvoiceseekerlight &
pulseaudio --start --log-target=syslog

/home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/btp &
sleep 2
/home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/VoicePlayer
