#/bin/sh

# Automatic connection
output="";
coproc bluetoothctl
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
