#!/bin/bash

reset_mage(){
    cd /srv/www/magento/
    rm -rf var/cache/*
    php "/srv/www/magento/index.php"
}


cd /srv/www/


#. scripts/system/ticktick.sh
#DATA=`cat scripts/installer_settings.json`
#tickParse "$DATA"

DATA=`cat scripts/installer_settings.json`
#the value we want to work with/may or may not be there
bs_MAGEversion=`jsonval $DATA "bs_MAGEversion"`
bs_dbhost=`jsonval $DATA "bs_dbhost"`
bs_dbname=`jsonval $DATA "bs_dbname"`
bs_dbuser=`jsonval $DATA "bs_dbuser"`
bs_dbpass=`jsonval $DATA "bs_dbpass"`
bs_url=`jsonval $DATA "bs_url"`
bs_adminfname=`jsonval $DATA "bs_adminfname"`
bs_adminlname=`jsonval $DATA "bs_adminlname"`
bs_adminemail=`jsonval $DATA "bs_adminemail"`
bs_adminuser=`jsonval $DATA "bs_adminuser"`
bs_adminpass=`jsonval $DATA "bs_adminpass"`
bs_install_sample=`jsonval $DATA "bs_install_sample"`


echo "a value at ${bs_MAGEversion}"


cd /srv/www/magento/ #move to the root web folder
echo
echo "We will clear any past install"
#check to see if mage is installed already
if [ -f /srv/www/magento/app/etc/local.xml ]
then
    echo "--clearing the installed mage"
    rm -rf /srv/www/magento/app/etc/local.xml #un-install mage
    rm -rf /srv/www/magento/app/code/community/* #un-install modules
    rm -rf /srv/www/magento/app/code/local/* #un-install modules
fi

echo "--Clear old caches reports and sessions"
    cd /srv/www/magento/ #move to the root web folder
    rm -rf ./var/cache/* ./var/session/* ./var/report/* ./var/locks/*
    rm -rf ./var/log/* ./app/code/core/Zend/Cache/* ./media/css/* ./media/js/*
echo
if [ -f /srv/www/scripts/mage/clean.sql ]
then
    mysql -u root -pblank $bs_dbname < /srv/www/scripts/magento/clean.sql | echo -e "\n Initial custom mage cleaning MySQL scripting..."
else
    echo -e "\n COUNLDN'T FIND THE CLEANER SQL FILE"
fi



#sample
if [[ $bs_install_sample == "true" ]]
then
    echo -n "Sample Data package present, now unzipping..."
    cp -af magento-sample-data-1.6.1.0/media/* media/
    cp -af magento-sample-data-1.6.1.0/magento_sample_data_for_1.6.1.0.sql data.sql
    cd /srv/www/magento/ #move to the root web folder
    chmod o+w var var/.htaccess app/etc
    chmod -R o+w media
    
    echo "Now installing Magento with sample data..."
    echo
    echo "Importing sample products..."
    mysql -h $bs_dbhost -u $bs_dbuser -p$bs_dbpass $bs_dbname < data.sql
    
fi






echo
echo "Installing Adminer..."
if [ ! -f /srv/www/magento/adminer.php ]
then
    wget "http://www.adminer.org/latest-mysql-en.php"  -O adminer.php
    wget "https://raw.github.com/vrana/adminer/master/designs/haeckel/adminer.css"  -O adminer.css
    
    #maybe this one later.  Dev package we put together
    #http://kahi.cz/blog/images/adminer-makeup/adminer331-kahi.zip
fi


#pear mage-setup .
#pear install magento-core/Mage_All_Latest-stable

#./mage mage-setup .
#./mage config-set preferred_state stable

echo
echo "Initializing PEAR registry..."
    ./mage mage-setup .

echo
echo "Downloading packages..."
    ./mage install magento-core Mage_All_Latest


echo
echo "Cleaning up files..."


rm -rf downloader/pearlib/cache/* downloader/pearlib/download/*
rm -rf magento/ magento-sample-data-1.6.1.0/
#rm -rf magento-1.7.0.2.tar.gz magento-sample-data-1.6.1.0.tar.gz data.sql
rm -rf index.php.sample .htaccess.sample php.ini.sample LICENSE.txt
rm -rf STATUS.txt LICENSE.html LICENSE_AFL.txt  RELEASE_NOTES.txt

echo
echo "Installing Magento..."

    php -f install.php --\
    --license_agreement_accepted yes \
    --locale en_US \
    --timezone America/Los_Angeles \
    --default_currency USD \
    --db_host $bs_dbhost \
    --db_name $bs_dbname \
    --db_user $bs_dbuser \
    --db_pass $bs_dbpass \
    --url $bs_url \
    --use_rewrites yes \
    --skip_url_validation yes \
    --use_secure no \
    --secure_base_url "" \
    --use_secure_admin no \
    --admin_firstname "$bs_adminfname" \
    --admin_lastname "$bs_adminlname" \
    --admin_email "$bs_adminemail" \
    --admin_username "$bs_adminuser" \
    --admin_password "$bs_adminpass"


    if [ -f /srv/database/init-mage.sql ]
    then
        mysql -u root -pblank < /srv/database/init-mage.sql | echo -e "\nInitial custom mage MySQL scripting..."
    else
        echo -e "\nNo custom MySQL scripting found in database/init-mage.sql, skipping..."
    fi
    
    cd /srv/www/magento/
    echo "Starting to import base WSU modules from connect"
    ./mage config-set preferred_state alpha
    ./mage clear-cache
    ./mage sync
    ./mage download community Flagbit_ChangeAttributeSet
    ./mage download community BL_CustomGrid
    ./mage download community Ewall_Autocrosssell
    ./mage download community FireGento_Pdf
    ./mage download community Custom_PDF_Invoice_Layout
    #./mage download community ASchroder_SMTPPro
    ./mage download community Semantium_MSemanticBasic
    
    #./mage install community Ewall_Autocrosssell
    #./mage install community FireGento_Pdf
    
    ./mage install community Flagbit_ChangeAttributeSet
    ./mage install community BL_CustomGrid
    
    echo "prime the cach"
    reset_mage

    echo "Starting to import base WSU modules from github"
    declare -A gitRepos
    #[repo]=gitUser
    gitRepos=([WSUMAGE-admin-base]=washingtonstateuniversity
        [WSUMAGE-theme-base]=washingtonstateuniversity
        [eventTickets]=jeremyBass
        [WSUMAGE-store-utilities]=washingtonstateuniversity
        [WSUMAGE-structured-data]=washingtonstateuniversity
        [Storeuser]=jeremyBass
        [sitemaps]=jeremyBass
        [webmastertools]=jeremyBass
        [WSUMAGE-ldap]=washingtonstateuniversity
        [pickupShipping]=jeremyBass
        [AdminQuicklancher]=jeremyBass
        [dropshippers]=jeremyBass
        [Aoe_FilePicker]=jeremyBass
        [mailing_services]=jeremyBass
        [WSUMAGE-iri-gateway]=washingtonstateuniversity
        #[custom_pdf_invoice]=jeremyBass
        [Aoe_Profiler]=jeremyBass           #https://github.com/fbrnc/Aoe_Profiler.git
        [Aoe_ManageStores]=jeremyBass       #https://github.com/fbrnc/Aoe_ManageStores.git
        [Aoe_LayoutConditions]=jeremyBass   #https://github.com/fbrnc/Aoe_LayoutConditions.git
        [Aoe_AsyncCache]=jeremyBass         #https://github.com/fbrnc/Aoe_AsyncCache.git
        [Aoe_ApiLog]=jeremyBass             #https://github.com/fbrnc/Aoe_ApiLog.git
        #[Inchoo_Logger]=ajzele             #https://github.com/ajzele/Inchoo_Logger.git
        [Aoe_ClassPathCache]=AOEmedia       #https://github.com/AOEmedia/Aoe_ClassPathCache.git
        [mage-enhanced-admin-grids]=mage-eag)
    cd /srv/www/magento/
    install_tarrepo_list $gitRepos 0 reset_mage
    unset gitRepos         #unset and re-declare to clear associative arrays
    declare -A gitRepos

    cd /srv/www/magento/

    echo "importing WSU favicon"
    wget -q http://images.wsu.edu/favicon.ico -O favicon.ico


    if [ -f /srv/database/init-mage-default-config.sql ]
    then
        mysql -u root -pblank < /srv/database/init-mage-default-config.sql | echo -e "\nInitial custom mage MySQL scripting..."
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
    php /srv/www/scripts/magento/install-post.php -- "$query"

    
    echo
    echo "doing the first index"
    echo
    cd shell && php -f indexer.php reindexall

    reset_mage
    mysql -u root -pblank $bs_dbname -e "DELETE FROM $bs_dbname.adminnotification_inbox;" | echo -e "\n >> Removed admin notifications ..."

    # Enable developer mode
    #if [ $MAG_DEVELOPER_MODE == 1 ]; then
    #    sed -i -e '/Mage::run/i\
    #Mage::setIsDeveloperMode(true);
    #' -e '1,$s//Mage::run/' $WWW_PATH/index.php
    #fi


    echo
    echo "Finished installing Magento"
    echo
