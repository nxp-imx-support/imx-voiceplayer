#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause

# Installation Script #
mkdir -vp /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo
cp -v /home/root/.nxp-demo-experience/demos.json /home/root/.nxp-demo-experience/demos.json_orig
cp -v ./bluetooth.svg /home/root/.nxp-demo-experience/icon/
cp -v ./demos.json /home/root/.nxp-demo-experience/
cp -v ./* /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/
rm /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/install.sh
