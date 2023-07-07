#!/bin/bash

# Copyright 2022-2023 NXP
# SPDX-License-Identifier: BSD-3-Clause

# Restore VoiceSeeker Audio Front-End

# Revert asound.conf
cp -v /etc/asound.conf_original /etc/asound.conf

# Revert Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini_original /unit_tests/nxp-afe/Config.ini
