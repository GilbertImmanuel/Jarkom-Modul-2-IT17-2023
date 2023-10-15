#!/bin/bash

# Add nameserver to /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

# Update package list
apt-get update

# Install BIND9
apt-get install bind9 -y

# Add DNS zone configurations to /etc/bind/named.conf.local
echo 'zone "arjuna.it17.com" {' >> /etc/bind/named.conf.local
echo '    type master;' >> /etc/bind/named.conf.local
echo '  notify yes;' >> /etc/bind/named.conf.local
echo '  also-notify { 10.72.2.3; };' >> /etc/bind/named.conf.local
echo '  allow-transfer { 10.72.2.3; };' >> /etc/bind/named.conf.local
echo '    file "/etc/bind/arjuna.it17/arjuna.it17.com";' >> /etc/bind/named.conff
.local
echo '};' >> /etc/bind/named.conf.local

# Create directory for arjuna.it17.com zone
mkdir -p /etc/bind/arjuna.it17

# Copy the default DNS zone file for arjuna.it17.com
cp /etc/bind/db.local /etc/bind/arjuna.it17/arjuna.it17.com

echo 'zone "abimanyu.it17.com" {' >> /etc/bind/named.conf.local
echo '    type master;' >> /etc/bind/named.conf.local
echo '  notify yes;' >> /etc/bind/named.conf.local
echo '  also-notify { 10.72.2.3; };' >> /etc/bind/named.conf.local
echo '  allow-transfer { 10.72.2.3; };' >> /etc/bind/named.conf.local
echo '    file "/etc/bind/abimanyu.it17/abimanyu.it17.com";' >> /etc/bind/named..
conf.local
echo '};' >> /etc/bind/named.conf.local


# Create the reverse DNS zone configuration
echo "zone \"1.72.10.in-addr.arpa\" {
    type "master";
    file \"/etc/bind/abimanyu.it17/1.72.10.in-addr.arpa\";
};" >> /etc/bind/named.conf.local


# Create directory for abimanyu.it17.com zone
mkdir -p /etc/bind/abimanyu.it17

# Copy the default DNS zone file for abimanyu.it17.com
cp /etc/bind/db.local /etc/bind/abimanyu.it17/abimanyu.it17.com
cp /etc/bind/db.local /etc/bind/abimanyu.it17/1.72.10.in-addr.arpa

echo ';
; BIND data file for local loopback interface
;
$TTL    2022100601
@       IN      SOA     arjuna.it17.com. root.arjuna.it17.com. (
                              2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      arjuna.it17.com.
@       IN      A       10.72.2.4
www     IN      CNAME   arjuna.it17.com.
@       IN      AAAA    ::1' > /etc/bind/arjuna.it17/arjuna.it17.com

zone_content='
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.it17.com. root.abimanyu.it17.com. (
                              2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      abimanyu.it17.com.
@       IN      A       10.72.1.4       ; ip abimanyu
www     IN      CNAME   abimanyu.it17.com.
parikesit     IN      A   10.72.1.4     ;
ns1     IN      A       10.72.2.3       ; ip werkudara
baratayuda IN   NS      ns1             ;
'
echo "$zone_content" > /etc/bind/abimanyu.it17/abimanyu.it17.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     abimanyu.it17.com. root.abimanyu.it17.com. (
                              2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
1.72.10.in-addr.arpa.       IN      NS      abimanyu.it17.com.
4       IN      PTR       abimanyu.it17.com.    ; ip abimanyu' > /etc/bind/abimaa
nyu.it17/1.72.10.in-addr.arpa

options_content='
options {
    //dnssec-validation auto;
    directory "/var/cache/bind";
    allow-query { any; };
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
'

echo "$options_content" > /etc/bind/named.conf.options
service bind9 restart
