#!/bin/sh
## Preparing all the variables like IP, Hostname, etc, all of them from the container
sleep 5
HOSTNAME=$(hostname -a)
DOMAIN=$(hostname -d)
CONTAINERIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

## Installing the DNS Server ##
echo "Configuring DNS Server"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
cat <<EOF >>/etc/dnsmasq.conf
  server=8.8.8.8
  listen-address=127.0.0.1
  domain=$DOMAIN
  mx-host=$DOMAIN,$HOSTNAME.$DOMAIN,0
  address=/$HOSTNAME.$DOMAIN/$CONTAINERIP
  user=root
EOF
sudo service dnsmasq restart

#Config timezone
/usr/bin/ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

##Install the Glpi ##
echo "Downloading glpi"
wget -O /opt/glpi-10.0.2.tgz https://github.com/glpi-project/glpi/releases/download/10.0.2/glpi-10.0.2.tgz

echo "Extracting files from the archive"
tar xzvf /opt/glpi-10.0.2.tgz -C /var/www/html/

chown -Rf www-data:www-data /var/www/html/glpi/

rm /etc/apache2/sites-available/000-default.conf

#Config apache
echo "Config apache"
cat <<EOF >>/etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName glpi.xxx.com.br

        ServerAdmin webmaster@localhost"
        DocumentRoot /var/www/html/glpi

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF

/etc/init.d/apache2 start

sleep 10

#Configuration according to instruction manual
#files glpi
mkdir /etc/glpi
echo "Configuration according to instruction manual"
touch /var/www/html/glpi/inc/downstream.php
cat <<EOF >>/var/www/html/glpi/inc/downstream.php
  <?php
    define('GLPI_CONFIG_DIR', '/etc/glpi/');

    if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
      require_once GLPI_CONFIG_DIR . '/local_define.php';
    }
EOF

touch /etc/glpi/local_define.php
cat <<EOF >>/etc/glpi/local_define.php
  <?php
   define('GLPI_VAR_DIR', '/var/lib/glpi');
  define('GLPI_LOG_DIR', '/var/log/glpi');
EOF

echo "Config glpi in system"
#files glpi
mv /var/www/html/glpi/config/* /etc/glpi/
chown -Rf www-data:www-data /etc/glpi/
chmod -Rf 775 /etc/glpi

#files data glpi
mkdir /var/lib/glpi
mv /var/www/html/glpi/files/* /var/lib/glpi/
chown -Rf www-data:www-data /var/lib/glpi/
chmod -Rf 775 /etc/glpi

#log glpi
mkdir /var/log/glpi
chown -Rf www-data:www-data /var/log/glpi
chmod -Rf 775 /var/log/glpi

echo "Update package cache"
apt update -y

sleep 5
/etc/init.d/apache2 restart

echo "You can access now to your Glpi Server"

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

