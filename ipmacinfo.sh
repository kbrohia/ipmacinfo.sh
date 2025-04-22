echo "=============Interface IPs:================"
if command -v ifconfig &> /dev/null
then
    echo "Interface IPs:"
    ifconfig | grep 'inet ' | awk '{print $2}'
elif command -v ip &> /dev/null
then
    echo "Interface IPs:"
    ip -4 addr show | grep inet | awk '{print $2}'
fi

echo " "
echo " "
echo "=============Wi-Fi MAC Addresses================"
# Find the Wi-Fi interface (usually en0 or en1)
wifi_interface=$(networksetup -listallhardwareports | \
    awk '/Wi-Fi|AirPort/{getline; print $2}')

# Get the MAC address of the Wi-Fi interface
if [ -n "$wifi_interface" ]; then
    mac_address=$(ifconfig $wifi_interface | awk '/ether/{print $2}')
    echo "Wi-Fi Interface: $wifi_interface"
    echo "MAC Address: $mac_address"
else
    echo "Wi-Fi interface not found."
fi
echo " "
echo "Nice one. Very cool."
