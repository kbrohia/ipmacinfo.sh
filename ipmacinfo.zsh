# Get Wi-Fi interface
wifi_interface=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')
wifi_summary=$(/usr/sbin/ipconfig getsummary "$wifi_interface")

if [ -n "$wifi_interface" ]; then
    mac_address=$(ifconfig $wifi_interface | awk '/ether/{print $2}')
    ip_address=$(ipconfig getifaddr $wifi_interface)
	ipv6_address=$(ifconfig $wifi_interface | awk '/inet6 / && !/fe80/ {print $2}' | head -n 1)
    ssid=$(ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}')
    bssid=$(echo "$wifi_summary" | awk -F 'BSSID : ' '/BSSID/ {print $2}')
    gateway=$(netstat -rn | grep default | awk '{print $2}')
    dns_servers=$(scutil --dns | awk '/nameserver\[/{print $3}' | sort -u | paste -s -d ' ')
    public_ip=$(curl -s https://api.ipify.org)

# Fallback to link-local if no global IPv6 found
if [ -z "$ipv6_address" ]; then
    ipv6_address=$(ifconfig $wifi_interface | awk '/inet6 / {print $2}' | head -n 1)
fi

    echo "===== Network Information ====="
    echo "Wi-Fi Interface: $wifi_interface"
    echo "MAC Address: $mac_address"
    echo "IPv4 Address: $ip_address"
    echo "IPv6 Address: $ipv6_address"
    echo "SSID: $ssid"
    echo "BSSID: $bssid"
    echo "Default Gateway: $gateway"
    echo "DNS Servers: $dns_servers"
    echo "Public IP: $public_ip"
else
    echo "Wi-Fi interface not found."
fi
