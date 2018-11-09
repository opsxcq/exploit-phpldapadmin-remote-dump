#!/bin/bash


if [ -z "$SITE" ]
then
    echo 'Prease inform an SITE variable, using default'
    SITE=localhost
fi

if [ -z "$ADMIN_EMAIL" ]
then
    echo 'Please inform an admin email, using default'
    ADMIN_EMAIL='root@localhost'
fi

if [ ! -f /etc/apache2/sites-enabled/000-default.conf ]
then
    echo '[+] Generating site configuration'
    cat > /etc/apache2/sites-enabled/000-default.conf << EOF
<VirtualHost *:80>
    ServerName ${SITE}
    ServerAdmin ${ADMIN_EMAIL}
    DocumentRoot /www
    <Directory /www>
        Options -Indexes
        AllowOverride all
        Require all granted
    </Directory>
    # Possible values include: debug, info, notice, warn, error, crit,
    # alert, emerg.
    LogLevel warn
     ErrorLog /dev/stderr
     TransferLog /dev/stdout
</VirtualHost>
EOF
fi

# Set apache variables
source /etc/apache2/envvars
apachectl -f /etc/apache2/apache2.conf

service slapd start

tail -f /var/log/apache2/*.log
