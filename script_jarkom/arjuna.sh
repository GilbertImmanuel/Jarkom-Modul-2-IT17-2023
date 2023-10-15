!/bin/bash

# Add nameserver to /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

# Update package list

apt-get update
apt install php
apt install php-fpm -y
apt-get install nginx
service nginx start

rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

content='<?php
$hostname = gethostname();
$date = date("Y-m-d H:i:s");
$php_version = phpversion();
$username = get_current_user();

echo "Hello World!<br>";
echo "Saya adalah: $username<br>";
echo "Saat ini berada di: $hostname<br>";
echo "Versi PHP yang saya gunakan: $php_version<br>";
echo "Tanggal saat ini: $date<br>";
?>'

# Create the index.php file and write the content
#echo "$content" > /var/www/arjuna.it17.com/index.php

lb_config=$(cat <<EOF
 upstream myweb  {
        server 10.72.1.4:8002; #IP Abimanyu
        server 10.72.1.5:8001; #IP prabukusuma
        server 10.72.1.6:8003; #IP Wisanggeni
 }

 server {
        listen 80;
        server_name arjuna.it17.com;

        location / {
        proxy_pass http://myweb;
        }
 } 
EOF
)

echo "$lb_config" > /etc/nginx/sites-available/lb-jarkom

ln -s /etc/nginx/sites-available/lb-jarkom /etc/nginx/sites-enabled

/etc/init.d/php7.2-fpm start

service nginx restart
