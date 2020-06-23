## Installation :

- Server minimal specifications : Ubuntu 16.04, 8GB RAM, Most ports open for testing purposes. The ports to close should be tested in the future.

- Run the script in the terminal, only after you replace `www.example.com` in it by your subdomain name used for live calls :

```
sudo bash live_setup.sh
```

- Next, edit the nginx configuration file `/etc/nginx/sites-available/bigbluebutton` and add the specified lines below. Ensure that you’re using the correct filenames to match the certificate and key files you created above (again, replace bigbluebutton.example.com with your hostname).

```
server {
  server_name bigbluebutton.example.com; ## Change DOmain name to match yours
  listen 80;
  listen [::]:80;

### ONly add what you see below this line
  listen 443 ssl;
  listen [::]:443 ssl;
  ## Change domain name to match yours
  ssl_certificate /etc/letsencrypt/live/bigbluebutton.example.com/fullchain.pem;
  # Chaange domain name to match yours
  ssl_certificate_key /etc/letsencrypt/live/bigbluebutton.example.com/privkey.pem;
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 10m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS:!AES256";
  ssl_prefer_server_ciphers on;
  ssl_dhparam /etc/nginx/ssl/dhp-4096.pem;

```


- Quit and save the file, and run the following command on terminal :

```
sudo crontab -e
```

- Add the following lines to the end of the file :

```
30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log
35 2 * * 1 /bin/systemctl reload nginx
```

- Configure Freeswitch for using SSL using the steps (here)[https://docs.bigbluebutton.org/2.2/install.html#configure-freeswitch-for-using-ssl].

- Configure BigBlueButton to load session via HTTPS using the steps (here)[https://docs.bigbluebutton.org/2.2/install.html#configure-bigbluebutton-to-load-session-via-https].

- Test your https configuration using the steps (here)[https://docs.bigbluebutton.org/2.2/install.html#test-your-https-configuration].

- Run on terminal :

```
sudo bbb-conf --restart
```

- Next run :

```
sudo bbb-conf --check
```

- In the resulting values, check the part of `/opt/freeswitch/etc/freeswitch/sip_profiles/external.xml (FreeSWITCH)`, if you got there a value of ` wss-binding: :7443`, you will need to modify it into : `wss-binding:52.189.236.89:7443` with `52.189.236.89` replaced by your server public IP. The modification can be made by running the command `nano /opt/freeswitch/etc/freeswitch/sip_profiles/external.xml` and modifying the value of `wss-binding`.
