## Installation of Moodle :

- Server specifications for Moodle : Ubuntu 18.04 , Ram Minimale 1GB, processeur Minimal : 1 processeur.

- Run on terminal :

```
bash initial_setup.sh
```

- You will be prompted to answer a series of questions after a bit of time :

```
    Enter current password for root (enter for none): Just press the Enter

    Set root password? [Y/n]: Y

    New password: Enter password

    Re-enter new password: Repeat password

    Remove anonymous users? [Y/n]: Y

    Disallow root login remotely? [Y/n]: Y

    Remove test database and access to it? [Y/n]:  Y

    Reload privilege tables now? [Y/n]:  Y

```

- We will now make some simple modifications with `nano /etc/mysql/mariadb.conf.d/50-server.cnf`

- In the Mysqld section, append the lines below

```
default_storage_engine = innodb
innodb_file_per_table = 1
innodb_file_format = Barracuda
innodb_large_prefix = 1
```

- Save the changes and exit your text editor.

- Finally, restart the MySQL database to effect the changes with :

```
systemctl restart mysql
```

- Next run the following command on terminal :

```
sudo apt install graphviz aspell ghostscript clamav php7.2-pspell php7.2-curl php7.2-gd php7.2-intl php7.2-mysql php7.2-xml php7.2-xmlrpc php7.2-ldap php7.2-zip php7.2-soap php7.2-mbstring
```

- We then create the MySQL Database :

```
sudo mysql -u root -p
```

- Create a database : `CREATE DATABASE moodledb;`

- Create Database user with password : `CREATE USER  'moodle'@'localhost'  IDENTIFIED BY  'new_password_here';`

- Grant access to database :

```
GRANT ALL ON moodledb.* TO 'moodle@localhost' IDENTIFIED BY 'user_password_here' WITH GRANT OPTION;
```

- Run then the following commands to exit :

```
FLUSH PRIVILEGES;
```

```
EXIT;
```

- Download a version of Moodle :

```
wget https://download.moodle.org/download.php/direct/stable35/moodle-latest-35.tgz
```

- Extract the file :

```
tar -zxvf moodle-latest-35.tgz
```

- Move Moodle to web root directory :

```
sudo mv moodle /var/www/html/moodle
```

- Create a new directory for serving :

```
sudo mkdir /var/www/html/moodledata
```

- Adjust file permissions :

```
sudo chown -R www-data:www-data /var/www/html/moodle/
sudo chmod -R 755 /var/www/html/moodle/
sudo chown www-data /var/www/html/moodledata
```

- We will then start the creation of a virtual host through  :

```
nano /etc/apache2/sites-available/moodle.conf
```

- Now put the following in the file, while also changing the `example.com` with your domain name :

```
<VirtualHost *:80>
ServerAdmin admin@example.com
DocumentRoot /var/www/html/moodle/
ServerName example.com
ServerAlias www.example.com

<Directory /var/www/html/moodle/>
Options +FollowSymlinks
AllowOverride All
Require all granted
</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

- Run the following afterward :

```
sudo a2enmod rewrite
sudo a2ensite moodle.conf
sudo a2dissite 000-default.conf
```

- Then run :

```
systemctl restart apache2
```

- You can next go to the link : `http://server-IP/install.php` to start the installation process, and there you'll enter your database credentials as specified before.
