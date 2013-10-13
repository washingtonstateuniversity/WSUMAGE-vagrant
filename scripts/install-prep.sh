#!/bin/bash
#this script takes way to long for my taste.. ADD yo
#run some wgets in the back groung to speed up the installation
cd /srv/www/

if [ ! -d /srv/www/mage/ ]
then
    mkdir mage
fi
cd /srv/www/mage/

#ensure we have the core files for mage
if [ ! -f /srv/www/mage/magento-$bs_MAGEversion.tar.gz ]
    then
        URLS=(
            http://www.magentocommerce.com/downloads/assets/$bs_MAGEversion/magento-$bs_MAGEversion.tar.gz
            http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz
        )
        for u in "${URLS[@]}"
        do
            echo "staring background download of " $u
            echo
            wget -bcq $u #push it to the background and keep it quite
        done
    fi

cd /srv/www/
mkdir default
cd /srv/www/default
