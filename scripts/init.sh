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
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Config.ini /unit_tests/nxp-afe
touch /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/mute.vol

/unit_tests/nxp-afe/afe libvoiceseekerlight  &
pulseaudio --start --log-target=syslog

if [[ $evk == "imx93-11x11-lpddr4x-evk" || $evk == "imx93evk" ]]
then
        /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/i.MX9X_A55/btp_vit -ddefault -l ENGLISH -t 100000 -i IMX9XA55 &
else
        /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/i.MX8M_A53/btp_vit -ddefault -l ENGLISH -t 100000 &
fi

sleep 2
/home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Btplayer
