#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause

# This script enables VIT to auto start

cp -v /opt/Btplayer/bin/Btplayer.service /etc/systemd/system
chmod 777 /etc/systemd/system/Btplayer.service
systemctl daemon-reload
systemctl enable Btplayer.service
sync
echo ""
echo "VIT Auto Start has been enabled"
echo "Please, restart ..."
echo ""
