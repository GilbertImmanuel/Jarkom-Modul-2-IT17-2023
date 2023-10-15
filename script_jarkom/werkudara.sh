#!/bin/bash

# Add nameserver to /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

# Update package list
apt-get update

apt-get install bind9 -y

mkdir /etc/bind/baratayuda

options_content='
options {
    directory "/var/cache/bind";

    allow-query { any; };

    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
'

echo "$options_content" > /etc/bind/named.conf.options

zone_baratayuda="zone \"baratayuda.abimanyu.it17.com\" {
    type master;
    file \"/etc/bind/baratayuda/baratayuda.abimanyu.it17.com\";
};"

zone_abimanyu="zone \"abimanyu.it17.com\" {
    type slave;
    masters { 10.72.2.2; };
    file \"/var/lib/bind/abimanyu.it17.com\";
};"

zone_arjuna="zone \"arjuna.it17.com\" {
    type slave;
    masters { 10.72.2.2; };
    file \"/var/lib/bind/arjuna.it17.com\";
};"

echo "$zone_baratayuda" >> /etc/bind/named.conf.local
echo "$zone_abimanyu" >> /etc/bind/named.conf.local
echo "$zone_arjuna" >> /etc/bind/named.conf.local

zone_content=";
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     baratayuda.abimanyu.it17.com. root.baratayuda.abimanyu.ii
t17.com(
                2022100601              ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      baratayuda.abimanyu.it17.com.
@       IN      A       10.72.1.4
www     IN      CNAME   baratayuda.abimanyu.it17.com.
rjp     IN      A       10.72.1.4
www.rjp IN      CNAME   baratayuda.abimanyu.it17.com.
@       IN      AAAA    ::1
"

echo "$zone_content" > /etc/bind/baratayuda/baratayuda.abimanyu.it17.com
service bind9 restart
