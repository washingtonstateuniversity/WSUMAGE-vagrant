#!/bin/bash

cd /srv/www/magento/

echo "importing WSU favicon"
wget -q http://images.wsu.edu/favicon.ico -O favicon.ico


if [ -f /srv/scripts/magento/init-mage-default-config.sql ]
then
    #mysql -u root -pblank < /srv/scripts/magento/init-mage-default-config.sql | echo -e "\nInitial custom mage MySQL scripting..."
else
    echo -e "\nNo custom MySQL scripting found in database/init-mage-default-config.sql, skipping..."
fi

echo "Removing unwanted bloat by uninstalling modules like paypal"
cd /srv/www/magento/
#rm -rf app/code/core/Mage/Paypal/* app/code/core/Mage/Paypal/*
#rm -rf app/design/adminhtml/default/default/template/paypal/*
echo "come back to this.. must remove any and all etra modules for the lightest base possible"

cp /srv/www/scripts/magento/settings.config settings.config #remove this I think.


##pass the shell variables to php via a query string to trun to an object in the post script
##maybe we should just load the installer settings json file from within the php?
query=
for var in ${!bs_*}; do
    if [ -n "$query" ];
    then query="$query&"
    fi
    query="$query${var#bs_}=${!var}"
done
#php /srv/www/scripts/magento/install-post.php -- "$query"