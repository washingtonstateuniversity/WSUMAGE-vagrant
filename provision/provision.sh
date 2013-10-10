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

## since we are generating from Mac or Windows this is needed 
apt-get install dos2unix
cd /srv/www/scripts/
find . -type f -exec dos2unix {} \; 


cd /srv/www/
. scripts/install-functions.sh

. scripts/install_settings.sh


if [[ has_network ]]
then
    apt-get install pv

    cd /srv/www/
    . scripts/install-prep.sh

    cd /srv/www/
    . scripts/main-install.sh

else
	echo -e "\nNo network connection available, skipping package installation"
fi


if [[ has_network ]]
then

    #check and install wp
    cd /srv/www/
    . scripts/db-install.sh   

    #check and install wp
    cd /srv/www/
    #. scripts/wp-install.sh   

    #check and install phpmyadmin
    cd /srv/www/
    #. scripts/phpmyadmin-install.sh   

    #check and install magento
    cd /srv/www/
    . scripts/mage-install.sh      

else
	echo -e "\nNo network available, skipping network installations"
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
if [[ has_network ]]
then
	echo "External network connection established, packages up to date."
    echo
    echo "-------------------------"
    echo
    echo "System creds"
    echo
    echo "-------------------------"
    echo
    echo "Database Host (usually localhost): $dbhost"
    echo
    echo "Database Name: $dbname"
    echo
    echo "Database User: $dbuser"
    echo
    echo "Database Password: $dbpass"
    echo
    echo "Store URL: $url"
    echo
    echo "Admin Username: $adminuser"
    echo
    echo "Admin Password: $adminpass"
    echo
    echo "Admin First Name: $adminfname"
    echo
    echo "Admin Last Name: $adminlname"
    echo
    echo "Admin Email Address: $adminemail"
    echo
    echo "For further setup instructions, visit http://$vvv_ip"
else
	echo "No external network available. Package installation and maintenance skipped."
fi
