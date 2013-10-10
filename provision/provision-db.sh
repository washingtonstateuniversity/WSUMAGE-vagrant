# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant as the primary
# provisioning script whenever the commands `vagrant up`, `vagrant provision`,
# or `vagrant reload` are used. It provides all of the default packages and
# configurations included with Varying Vagrant Vagrants. 
# It's worth noting that you dont' need the normal #!/bin/bash for this included file

# By storing the date now, we can calculate the duration of provisioning at the
# end of this script.
start_seconds=`date +%s`

cd /srv/www/
. scripts/install-functions.sh

if [[ has_network ]]
then
    apt_package_install_list=()
    
    # Start with a bash array containing all packages we want to install in the
    # virtual machine. We'll then loop through each of these and check individual
    # status before adding them to the apt_package_install_list array.
    apt_package_check_list=(
        # memcached is made available for object caching
        memcached
    
        # mysql is the default database
        mysql-server
    
        # other packages that come in handy
        git-core
        unzip
        ngrep
        curl
        make
    
        # dos2unix
        # Allows conversion of DOS style line endings to something we'll have less
        # trouble with in Linux.
        dos2unix
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

    # SYMLINK HOST FILES
    echo -e "\nSetup configuration file links..."

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

    # Capture the current IP address of the virtual machine into a variable that
    # can be used when necessary throughout provisioning.
    vvv_ip=`ifconfig eth1 | ack "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1`

    # RESTART SERVICES
    #
    # Make sure the services we expect to be running are running.
    echo -e "\nRestart services..."
    service memcached restart

    cd /srv/www/
    . scripts/db-install.sh   
else
	echo -e "\nNo network connection available, skipping package installation"
fi

# Add any custom domains to the virtual machine's hosts file so that it
# is self aware. Enter domains space delimited as shown with the default.
DOMAINS='local.mage.dev local.wordpress.dev local.wordpress-trunk.dev src.wordpress-develop.dev build.wordpress-develop.dev'
if ! grep -q "$DOMAINS" /etc/hosts
then echo "127.0.0.1 $DOMAINS" >> /etc/hosts
fi

end_seconds=`date +%s`
echo "-----------------------------"
echo "Provisioning complete in `expr $end_seconds - $start_seconds` seconds"