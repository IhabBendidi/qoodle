#!/bin/bash

wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v xenial-220 -a
sudo bbb-conf --setip www.example.com
mkdir /etc/nginx/ssl
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install -y certbot
sudo openssl dhparam -out /etc/nginx/ssl/dhp-4096.pem 4096
sudo certbot --webroot -w /var/www/bigbluebutton-default/ -d www.example.com certonly
