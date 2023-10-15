# Update package list
apt-get update
apt install dnsutils
apt install lynx

echo "nameserver 10.72.2.2" > /etc/resolv.conf
echo "nameserver 10.72.2.3" >> /etc/resolv.conf
