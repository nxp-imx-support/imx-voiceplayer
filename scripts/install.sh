#!/bin/bash

# Copyright 2022-2023 NXP                                                                                                              
# SPDX-License-Identifier: BSD-3-Clause

# Installation Script #
mkdir -vp /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer
cp -v /home/root/.nxp-demo-experience/demos.json /home/root/.nxp-demo-experience/demos.json_orig
cp -v ./bluetooth.svg /home/root/.nxp-demo-experience/icon/
cp -v ./demos.json /home/root/.nxp-demo-experience/
cp -v ./WakeWordNotify /usr/bin/
cp -v ./WWCommandNotify /usr/bin/
cp -v ./volume.sh /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/
cp -vr ./* /home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/
