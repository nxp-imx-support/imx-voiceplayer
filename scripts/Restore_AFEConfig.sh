#!/bin/bash

# Copyright 2022-2024 NXP
# SPDX-License-Identifier: BSD-3-Clause

# Restore VoiceSeeker Audio Front-End

# Revert asound.conf
cp -v /etc/asound.conf_original /etc/asound.conf

# Revert Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini_original /unit_tests/nxp-afe/Config.ini

# Stop Audio services and revert demo audio Sink
systemctl --user stop pipewire wireplumber
sleep 2s
rm -vrf /etc/pipewire
