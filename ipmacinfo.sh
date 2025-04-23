#!/bin/bash

# Get Wi-Fi interface
wifi_interface=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')

if [ -n "$wifi_interface" ]; then
    mac_address=$(ifconfig $wifi_interface | awk '/ether/{print $2}')
    ip_address=$(ipconfig getifaddr $wifi_interface)
    ipv6_address=$(ifconfig $wifi_interface | awk '/inet6 / && !/fe80/ {print $2}')
    ssid=$(networksetup -getairportnetwork $wifi_interface | awk -F': ' '{print $2}')
    bssid=$(airport -I | awk '/BSSID/ {print $2}')
    rssi=$(airport -I | awk '/agrCtlRSSI/ {print $2}')
    noise=$(airport -I | awk '/agrCtlNoise/ {print $2}')
    gateway=$(netstat -rn | grep default | awk '{print $2}')
    dns_servers=$(networksetup -getdnsservers $wifi_interface | grep -v "There aren't any")
    public_ip=$(curl -s https://api.ipify.org)
    
    echo "===== Network Information ====="
    echo "Wi-Fi Interface: $wifi_interface"
    echo "MAC Address: $mac_address"
    echo "IPv4 Address: $ip_address"
    echo "IPv6 Address: $ipv6_address"
    echo "SSID: $ssid"
    echo "BSSID: $bssid"
    echo "Signal Strength (RSSI): $rssi dBm"
    echo "Noise Level: $noise dBm"
    echo "Default Gateway: $gateway"
    echo "DNS Servers:"
    echo "$dns_servers"
    echo "Public IP: $public_ip"
else
    echo "Wi-Fi interface not found."
fi
