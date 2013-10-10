#!/bin/bash

cd /srv/www/

# WP-CLI Install
if [ ! -d /srv/www/wp-cli ]
then
    echo -e "\nDownloading wp-cli, see http://wp-cli.org"
    git clone git://github.com/wp-cli/wp-cli.git /srv/www/wp-cli
    cd /srv/www/wp-cli
    composer install
else
    echo -e "\nUpdating wp-cli..."
    cd /srv/www/wp-cli
    git pull --rebase origin master
    composer update
fi
# Link `wp` to the `/usr/local/bin` directory
ln -sf /srv/www/wp-cli/bin/wp /usr/local/bin/wp

# Webgrind install (for viewing callgrind/cachegrind files produced by
# xdebug profiler)
if [ ! -d /srv/www/default/webgrind ]
then
    echo -e "\nDownloading webgrind, see https://github.com/jokkedk/webgrind"
    git clone git://github.com/jokkedk/webgrind.git /srv/www/default/webgrind

    echo -e "\nLinking webgrind config file..."
    ln -sf /srv/config/webgrind-config.php /srv/www/default/webgrind/config.php | echo " * /srv/config/webgrind-config.php -> /srv/www/default/webgrind/config.php"
else
    echo -e "\nUpdating webgrind..."
    cd /srv/www/default/webgrind
    git pull --rebase origin master
fi

# Install and configure the latest stable version of WordPress
if [ ! -d /srv/www/wordpress-default ]
then
    echo "Downloading WordPress Stable, see http://wordpress.org/"
    cd /srv/www/
    curl -O http://wordpress.org/latest.tar.gz
    tar -xvf latest.tar.gz
    mv wordpress wordpress-default
    rm latest.tar.gz
    cd /srv/www/wordpress-default
    echo "Configuring WordPress Stable..."
    wp core config --dbname=wordpress_default --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP
    wp core install --url=local.wordpress.dev --quiet --title="Local WordPress Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"
else
    echo "Updating WordPress Stable..."
    cd /srv/www/wordpress-default
    wp core upgrade
fi

# Checkout, install and configure WordPress trunk via core.svn
if [ ! -d /srv/www/wordpress-trunk ]
then
    echo "Checking out WordPress trunk from core.svn, see http://core.svn.wordpress.org/trunk"
    svn checkout http://core.svn.wordpress.org/trunk/ /srv/www/wordpress-trunk
    cd /srv/www/wordpress-trunk
    echo "Configuring WordPress trunk..."
    wp core config --dbname=wordpress_trunk --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP
    wp core install --url=local.wordpress-trunk.dev --quiet --title="Local WordPress Trunk Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"
else
    echo "Updating WordPress trunk..."
    cd /srv/www/wordpress-trunk
    svn up --ignore-externals
fi

# Checkout, install and configure WordPress trunk via develop.svn
if [ ! -d /srv/www/wordpress-develop ]
then
    echo "Checking out WordPress trunk from develop.svn, see http://develop.svn.wordpress.org/trunk"
    svn checkout http://develop.svn.wordpress.org/trunk/ /srv/www/wordpress-develop
    cd /srv/www/wordpress-develop/src/
    echo "Configuring WordPress develop..."
    wp core config --dbname=wordpress_develop --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP
    wp core install --url=src.wordpress-develop.dev --quiet --title="WordPress Develop" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"
    cp /srv/config/wordpress-config/wp-tests-config.php /srv/www/wordpress-develop/tests/
else
    echo "Updating WordPress trunk..."
    cd /srv/www/wordpress-develop/
    svn up
fi

if [ ! -d /srv/www/wordpress-develop/build ]
then
    echo "Initializing grunt in WordPress develop..."
    cd /srv/www/wordpress-develop/
    npm install
    grunt
fi