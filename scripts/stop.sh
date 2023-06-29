#/bin/sh

# Check if Btplayer is running
echo "Bt Player Stop Script"
while [ "$(ps -a | grep Btplayer)" != "" ]
do
        sleep 1
done

echo "Disconnect"
bluetoothctl disconnect
