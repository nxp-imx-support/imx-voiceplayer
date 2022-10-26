#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause

# modprobe snd-aloop

# Run VoiceSpot and AFE
#/opt/Btplayer/bin/VoiceSpot &
#/opt/Btplayer/bin/afe libvoiceseekerlight &

# Run VIT
modprobe snd-aloop

cp -v /etc/asound.conf /etc/asound.conf_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/asound.conf /etc

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Config.ini /unit_tests/nxp-afe

/unit_tests/nxp-afe/afe libvoiceseekerlight  &
pulseaudio --start --log-target=syslog

/home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/btp_vit -ddefault -l ENGLISH -t 1000000 &
sleep 2
/home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Btplayer
