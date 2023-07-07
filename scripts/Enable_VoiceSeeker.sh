#!/bin/bash

# Copyright 2022-2023 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause

# Enable VoiceSeeker Audio Front-End

# Copy asound.conf
cp -v /etc/asound.conf /etc/asound.conf_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/asound.conf /etc

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/Config.ini /unit_tests/nxp-afe

