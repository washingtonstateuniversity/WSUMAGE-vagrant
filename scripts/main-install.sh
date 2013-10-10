#!/bin/bash
# PACKAGE INSTALLATION
#
# Build a bash array to pass all of the packages we want to install to a single
# apt-get command. This avoids doing all the leg work each time a package is
# set to install. It also allows us to easily comment out or add single
# packages. We set the array as empty to begin with so that we can append
# individual packages to it as required.
apt_package_install_list=()

# Start with a bash array containing all packages we want to install in the
# virtual machine. We'll then loop through each of these and check individual
# status before adding them to the apt_package_install_list array.
apt_package_check_list=(
    #so we can hide some things by watching the pipes
    pv

	# PHP5
	#
	# Our base packages for php5. As long as php5-fpm and php5-cli are
	# installed, there is no need to install the general php5 package, which
	# can sometimes install apache as a requirement.
	php5-fpm
	php5-cli

	# Common and dev packages for php
	php5-common
	php5-dev

	# Extra PHP modules that we find useful
	php5-memcache
	php5-imagick
	php5-xdebug
	php5-mcrypt
	php5-mysql
	php5-imap
	php5-curl
	php-pear
	php5-gd
    php5-ldap
	php-apc

	# nginx is installed as the default web server
	nginx

	# memcached is made available for object caching
	memcached

	# mysql is the default database
	mysql-server

	# other packages that come in handy
	imagemagick
	subversion
	git-core
	unzip
	ngrep
	curl
	make
	#vim no, nano.. ha
	colordiff
    


	# Req'd for Webgrind
	graphviz

	# dos2unix
	# Allows conversion of DOS style line endings to something we'll have less
	# trouble with in Linux.
	dos2unix

	# nodejs for use by grunt
	g++
	nodejs

)

echo "Check for apt packages to install..."

# Loop through each of our packages that should be installed on the system. If
# not yet installed, it should be added to the array of packages to install.
for pkg in "${apt_package_check_list[@]}"
do
	package_version=`dpkg -s $pkg 2>&1 | grep 'Version:' | cut -d " " -f 2`
	if [[ $package_version != "" ]]
	then
		space_count=`expr 20 - "${#pkg}"` #11
		pack_space_count=`expr 30 - "${#package_version}"`
		real_space=`expr ${space_count} + ${pack_space_count} + ${#package_version}`
		printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
	else
		echo " *" $pkg [not installed]
		apt_package_install_list+=($pkg)
	fi
done


    



# MySQL
#
# Use debconf-set-selections to specify the default password for the root MySQL
# account. This runs on every provision, even if MySQL has been installed. If
# MySQL is already installed, it will not affect anything. The password in the
# following two lines *is* actually set to the word 'blank' for the root user.
echo mysql-server mysql-server/root_password password blank | debconf-set-selections
echo mysql-server mysql-server/root_password_again password blank | debconf-set-selections

# Provide our custom apt sources before running `apt-get update`
ln -sf /srv/config/apt-source-append.list /etc/apt/sources.list.d/vvv-sources.list | echo "Linked custom apt sources"


	# If there are any packages to be installed in the apt_package_list array,
	# then we'll run `apt-get update` and then `apt-get install` to proceed.
	if [ ${#apt_package_install_list[@]} = 0 ];
	then
		echo -e "No apt packages to install.\n"
	else
		# Before running `apt-get update`, we should add the public keys for
		# the packages that we are installing from non standard sources via
		# our appended apt source.list

		# Nginx.org nginx key ABF5BD827BD9BF62
		gpg -q --keyserver keyserver.ubuntu.com --recv-key ABF5BD827BD9BF62
		gpg -q -a --export ABF5BD827BD9BF62 | apt-key add -

		# Launchpad Subversion key EAA903E3A2F4C039
		gpg -q --keyserver keyserver.ubuntu.com --recv-key EAA903E3A2F4C039
		gpg -q -a --export EAA903E3A2F4C039 | apt-key add -

		# Launchpad PHP key 4F4EA0AAE5267A6C
		gpg -q --keyserver keyserver.ubuntu.com --recv-key 4F4EA0AAE5267A6C
		gpg -q -a --export 4F4EA0AAE5267A6C | apt-key add -

		# Launchpad git key A1715D88E1DF1F24
		gpg -q --keyserver keyserver.ubuntu.com --recv-key A1715D88E1DF1F24
		gpg -q -a --export A1715D88E1DF1F24 | apt-key add -

		# Launchpad nodejs key C7917B12 
		gpg -q --keyserver keyserver.ubuntu.com --recv-key C7917B12 
		gpg -q -a --export  C7917B12  | apt-key add -

		# update all of the package references before installing anything
		echo "Running apt-get update..."
		apt-get update --assume-yes

		# install required packages
		echo "Installing apt-get packages..."
		apt-get install --assume-yes ${apt_package_install_list[@]}

		# Clean up apt caches
		apt-get clean
	fi


    cd /srv/www/
    . scripts/system/ack-grep-install.sh

    cd /srv/www/
    #. scripts/system/composer-install.sh

    cd /srv/www/
    #. scripts/system/phpunit-install.sh

    cd /srv/www/
    #. scripts/system/grunt-install.sh


# Configuration for nginx
if [ ! -e /etc/nginx/server.key ]; then
	echo "Generate Nginx server private key..."
	vvvgenrsa=`openssl genrsa -out /etc/nginx/server.key 2048 2>&1`
	echo $vvvgenrsa
fi
if [ ! -e /etc/nginx/server.csr ]; then
	echo "Generate Certificate Signing Request (CSR)..."
	openssl req -new -batch -key /etc/nginx/server.key -out /etc/nginx/server.csr
fi
if [ ! -e /etc/nginx/server.crt ]; then
	echo "Sign the certificate using the above private key and CSR..."
	vvvsigncert=`openssl x509 -req -days 365 -in /etc/nginx/server.csr -signkey /etc/nginx/server.key -out /etc/nginx/server.crt 2>&1`
	echo $vvvsigncert
fi

# SYMLINK HOST FILES
echo -e "\nSetup configuration file links..."

ln -sf /srv/config/nginx-config/nginx.conf /etc/nginx/nginx.conf | echo " * /srv/config/nginx-config/nginx.conf -> /etc/nginx/nginx.conf"
ln -sf /srv/config/nginx-config/nginx-wp-common.conf /etc/nginx/nginx-wp-common.conf | echo " * /srv/config/nginx-config/nginx-wp-common.conf -> /etc/nginx/nginx-wp-common.conf"

# Configuration for php5-fpm
ln -sf /srv/config/php5-fpm-config/www.conf /etc/php5/fpm/pool.d/www.conf | echo " * /srv/config/php5-fpm-config/www.conf -> /etc/php5/fpm/pool.d/www.conf"

# Provide additional directives for PHP in a custom ini file
ln -sf /srv/config/php5-fpm-config/php-custom.ini /etc/php5/fpm/conf.d/php-custom.ini | echo " * /srv/config/php5-fpm-config/php-custom.ini -> /etc/php5/fpm/conf.d/php-custom.ini"

# Configuration for Xdebug
ln -sf /srv/config/php5-fpm-config/xdebug.ini /etc/php5/fpm/conf.d/xdebug.ini | echo " * /srv/config/php5-fpm-config/xdebug.ini -> /etc/php5/fpm/conf.d/xdebug.ini"

# Configuration for APC
ln -sf /srv/config/php5-fpm-config/apc.ini /etc/php5/fpm/conf.d/apc.ini | echo " * /srv/config/php5-fpm-config/apc.ini -> /etc/php5/fpm/conf.d/apc.ini"

# Configuration for mysql
cp /srv/config/mysql-config/my.cnf /etc/mysql/my.cnf | echo " * /srv/config/mysql-config/my.cnf -> /etc/mysql/my.cnf"

# Configuration for memcached
ln -sf /srv/config/memcached-config/memcached.conf /etc/memcached.conf | echo " * /srv/config/memcached-config/memcached.conf -> /etc/memcached.conf"

# Custom bash_profile for our vagrant user
ln -sf /srv/config/bash_profile /home/vagrant/.bash_profile | echo " * /srv/config/bash_profile -> /home/vagrant/.bash_profile"

# Custom bash_aliases included by vagrant user's .bashrc
ln -sf /srv/config/bash_aliases /home/vagrant/.bash_aliases | echo " * /srv/config/bash_aleases -> /home/vagrant/.bash_aliases"

# Custom home bin directory
ln -nsf /srv/config/homebin /home/vagrant/bin | echo " * /srv/config/homebin -> /home/vagrant/bin"

# Custom vim configuration via .vimrc
# ln -sf /srv/config/vimrc /home/vagrant/.vimrc | echo " * /srv/config/vimrc -> /home/vagrant/.vimrc"

# Capture the current IP address of the virtual machine into a variable that
# can be used when necessary throughout provisioning.
vvv_ip=`ifconfig eth1 | ack "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1`


#setup the mail
debconf-set-selections <<< "postfix postfix/mailname string local.mage.dev"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install -y postfix
#sudo apt-get install -y courier-pop
#sudo apt-get install -y courier-imap
sudo postconf -e "mydestination = mail.local.mage.dev, localhost.localdomain, localhost, local.mage.dev"
#sudo postconf -e "mynetworks = 127.0.0.0/8, 192.168.50.4/24"
sudo postconf -e "inet_interfaces = all"
sudo postconf -e "inet_protocols = all" ## make ip6 ready
sudo  /etc/init.d/postfix restart



# RESTART SERVICES
#
# Make sure the services we expect to be running are running.
echo -e "\nRestart services..."
service nginx restart
# Disable PHP Xdebug module by default
#php5dismod xdebug

service php5-fpm restart
service memcached restart
