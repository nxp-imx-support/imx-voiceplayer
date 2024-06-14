#!/bin/bash

# Copyright 2022-2024 NXP
# SPDX-License-Identifier: BSD-3-Clause

# Automatic connection
output="";
coproc bluetoothctl

# pid of the command launched
ID=$!
echo "pid of the command launched:$ID";
for (( a=1; a<4; a++ ))
do
	read output <&${COPROC[0]}
        echo "$output";
done
sleep 4
for (( b=1; b<11; b++ ))
do
        echo -e 'yes\n' >&${COPROC[1]}
        sleep .5
done
kill ${ID}
echo "Kill:$ID";
