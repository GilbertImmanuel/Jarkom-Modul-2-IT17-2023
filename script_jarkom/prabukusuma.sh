#!/bin/bash
  
# Add nameserver to /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

# Update package list
apt-get update
apt install nginx php php-fpm -y

# Replace all occurrences of "abimanyu.it17" with "prabukusuma" in the followingg
 commands

mkdir /var/www/prabukusuma.it17.com

server_config=$(cat <<EOF
server {
    listen 8001;
    root /var/www/prabukusuma.it17.com;
    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    error_log /var/log/nginx/prabukusuma.log;
    access_log /var/log/nginx/prabukusuma.log;
}
EOF
)

output_file="/etc/nginx/sites-available/prabukusuma.it17.com"
echo "$server_config" > "$output_file"

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
echo "$content" > /var/www/prabukusuma.it17.com/index.php

ln -s /etc/nginx/sites-available/prabukusuma.it17.com /etc/nginx/sites-enabled

service nginx restart

/etc/init.d/php7.2-fpm start
