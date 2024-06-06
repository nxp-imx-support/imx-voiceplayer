#!/bin/bash

# Copyright 2022-2023 NXP
# SPDX-License-Identifier: BSD-3-Clause

currentvol=`dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0/dev_$1/fd0 org.freedesktop.DBus.Properties.Get string:org.bluez.MediaTransport1 string:Volume | cut -d" " -f 12`
echo "current volume"
echo $currentvol

if [ $2 = 1 ]; then
	echo "increment" 
	newvol=$(($currentvol + 15))
	if [ $newvol -ge 125 ]; then
		newvol=125
	fi
        echo "New volume"
	echo $newvol
	dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0/dev_$1/fd0 org.freedesktop.DBus.Properties.Set string:org.bluez.MediaTransport1 string:Volume variant:uint16:$newvol
elif [ $2 = 2 ]; then
	echo "decrement"
	if [ $currentvol -ge 20 ]; then
        	newvol=$(($currentvol - 15))
        else
		newvol=0
        fi 
        echo "New volume"
	echo $newvol
	dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0/dev_$1/fd0 org.freedesktop.DBus.Properties.Set string:org.bluez.MediaTransport1 string:Volume variant:uint16:$newvol
else
	echo "mute"
        if [ $currentvol -eq 0 ]; then
        	echo "volume read"
                while IFS= read -r line
		do
  		echo "$line"
  		currentvol=$line
		done < /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/mute.vol
                dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0/dev_$1/fd0 org.freedesktop.DBus.Properties.Set string:org.bluez.MediaTransport1 string:Volume variant:uint16:$currentvol
        else        
                echo $currentvol > /opt/gopoint-apps/scripts/multimedia/imx-voiceplayer/mute.vol
                echo "Volume save"
                echo $currentvol
                printenv
	        dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0/dev_$1/fd0 org.freedesktop.DBus.Properties.Set string:org.bluez.MediaTransport1 string:Volume variant:uint16:0
        fi
fi
