#! /run/current-system/sw/bin/sh

eth=$(nmcli dev | grep ethernet | grep -w connected)
wifi=$(nmcli dev | grep wifi | grep -w connected)

if [ -n "$eth" ]; then
    if [ -n "$wifi" ]; then
	echo "ETH | WiFi"
    else
	echo "ETH"
    fi
elif [ -n "$wifi" ]; then
    echo "WiFi"
else
    echo "no internet"
fi
