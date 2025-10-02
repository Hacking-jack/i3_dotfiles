#!/bin/bash
wifi=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
echo "${wifi:-Desconectado}"
