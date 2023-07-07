#/bin/bash

# Copyright 2022-2023 NXP                                                                                                              
# SPDX-License-Identifier: BSD-3-Clause

# Check if Btplayer is running
echo "Bt Player Stop Script"
while [ "$(ps -a | grep Btplayer)" != "" ]
do
        sleep 1
done

echo "Disconnect"
bluetoothctl disconnect
