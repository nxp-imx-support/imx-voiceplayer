#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause


uname -n > /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/device.txt
evk=$(uname -n);

echo -e "Evk:${evk}";
cp -v /etc/asound.conf /etc/asound.conf_original

if  [[ $evk == "imx8mp-lpddr4-evk" || $evk == "imx8mpevk" ]]
then
	cp -v /unit_tests/nxp-afe/asound.conf_imx8mp /etc/asound.conf
else
	cp -v /unit_tests/nxp-afe/asound.conf /etc/asound.conf
fi

modprobe snd-aloop

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Config.ini /unit_tests/nxp-afe
touch /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mute.vol

/unit_tests/nxp-afe/afe libvoiceseekerlight  &
pulseaudio --start --log-target=syslog

/home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/btp_vit -ddefault -l ENGLISH -t 1000000 &
sleep 2
/home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Btplayer
