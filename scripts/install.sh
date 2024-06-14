#!/bin/bash

# Copyright 2022-2024 NXP
# SPDX-License-Identifier: BSD-3-Clause

# Installation Script #
mkdir -vp opt/gopoint-apps/scripts/multimedia/imx-voiceplayer
cp -v /opt/gopoint-apps/scripts/multimedia/demos.json /opt/gopoint-apps/scripts/multimedia/demos.json_orig
cp -v ./bluetooth.svg /opt/gopoint-apps/scripts/multimedia/icon/
cp -v ./demos.json /opt/gopoint-apps/scripts/multimedia/
cp -v ./WakeWordNotify /usr/bin/
cp -v ./WWCommandNotify /usr/bin/
cp -v ./volume.sh /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/
cp -vr ./* /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/
