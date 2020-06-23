#!/bin/bash

sudo -s
apt update -y && sudo apt upgrade -y
apt install apache2
systemctl start apache2
systemctl status apache2
apt install mysql-client mysql-server php libapache2-mod-php
systemctl start mysql
systemct enable mysql
mysql_secure_installation
