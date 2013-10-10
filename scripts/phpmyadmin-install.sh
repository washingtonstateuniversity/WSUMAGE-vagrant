#!/bin/bash

cd /srv/www/
# Download phpMyAdmin 4.0.3
if [ ! -d /srv/www/default/database-admin ]
then
    echo "Downloading phpMyAdmin 4.0.3..."
    cd /srv/www/default
    if [ ! -f /srv/www/default/phpmyadmin.tar.gz ]
    then
        wget -q -O phpmyadmin.tar.gz 'http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.0.3/phpMyAdmin-4.0.3-english.tar.gz/download#!md5!07dc6ed4d65488661d2581de8d325493'
    fi
    pv phpmyadmin.tar.gz | tar xzf - -C ./
    #tar -xf phpmyadmin.tar.gz
    mv phpMyAdmin-4.0.3-english database-admin
    rm phpmyadmin.tar.gz
else
    echo "PHPMyAdmin 4.0.3 already installed."
fi