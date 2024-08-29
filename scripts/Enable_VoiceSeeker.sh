#!/bin/bash

# Copyright 2022-2024 NXP
# SPDX-License-Identifier: BSD-3-Clause

# Enable VoiceSeeker Audio Front-End

# Copy asound.conf
cp -v /etc/asound.conf /etc/asound.conf_original
cp -v /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/asound.conf /etc

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/Config.ini /unit_tests/nxp-afe

