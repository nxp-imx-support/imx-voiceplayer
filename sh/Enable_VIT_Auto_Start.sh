#!/bin/sh

# This script enables VIT to auto start #

cp -v /opt/Btplayer/bin/Btplayer.service /etc/systemd/system
chmod 777 /etc/systemd/system/Btplayer.service
systemctl daemon-reload
systemctl enable Btplayer.service
sync
echo ""
echo "VIT Auto Start has been enabled"
echo "Please, restart ..."
echo ""
