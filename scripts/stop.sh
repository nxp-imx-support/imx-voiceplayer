#/bin/bash

# Copyright 2022-2023 NXP                                                                                                              
# SPDX-License-Identifier: BSD-3-Clause

# Check if VoicePlayer is running
echo "Voice Player Stop Script"
while [ "$(ps -a | grep VoicePlayer)" != "" ]
do
        sleep 1
done

echo "Disconnect"
bluetoothctl disconnect
