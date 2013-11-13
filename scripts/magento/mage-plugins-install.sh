#!/bin/bash


cd /srv/www/magento/


./mage download community Aschroder_SetStartOrderNumber
./mage download community ASchroder_SMTPPro
./mage download community Semantium_MSemanticBasic
./mage download community FailedLoginTracker
#./mage install community Semantium_MSemanticBasic
#./mage install community BL_CustomGrid


echo "prime the cach"
reset_mage

echo "Starting to import base WSU modules from github"
declare -A gitRepos
gitRepos=(
    [WSUMAGE-store-utilities]=washingtonstateuniversity
)
install_tarrepo_list $gitRepos 0 reset_mage
unset gitRepos         #unset and re-declare to clear associative arrays
declare -A gitRepos


#[repo]=gitUser
gitRepos=(
<<<<<<< HEAD
    [WSUMAGE-networksecurities]=washingtonstateuniversity
    [WSUMAGE-admin-base]=washingtonstateuniversity
    [WSUMAGE-theme-base]=washingtonstateuniversity
    [WSUMAGE-auditing]=washingtonstateuniversity
    [WSUMAGE-structured-data]=washingtonstateuniversity
    [WSUMAGE-iri-gateway]=washingtonstateuniversity
    [mailing_services]=jeremyBass
    [eventTickets]=jeremyBass 
    [Storeuser]=jeremyBass
    [sitemaps]=jeremyBass
    [webmastertools]=jeremyBass
    [pickupShipping]=jeremyBass
    [AdminQuicklancher]=jeremyBass
    #[dropshippers]=jeremyBass
    [Aoe_FilePicker]=jeremyBass
    [WSUMAGE-pdf-service]=jeremyBass
    [Aoe_Profiler]=jeremyBass              #https://github.com/fbrnc/Aoe_Profiler.git
    [Aoe_ManageStores]=jeremyBass          #https://github.com/fbrnc/Aoe_ManageStores.git
    [Aoe_AsyncCache]=jeremyBass            #https://github.com/fbrnc/Aoe_AsyncCache.git
    [Aoe_ClassPathCache]=AOEmedia          #https://github.com/AOEmedia/Aoe_ClassPathCache.git
    [Aoe_Scheduler]=fbrnc          #https://github.com/fbrnc/Aoe_Scheduler.git
    [Aoe_ModelCache]=AOEmedia          #https://github.com/AOEmedia/Aoe_ModelCache
    #[Aoe_Eav]=AOEmedia          #https://github.com/AOEmedia/Aoe_Eav  
    #[Aoe_TemplateHints]=fbrnc
    [mage-enhanced-admin-grids]=jeremyBass #https://github.com/mage-eag/mage-enhanced-admin-grids.git
)
cd /srv/www/magento/
install_tarrepo_list $gitRepos 0 reset_mage
unset gitRepos         #unset and re-declare to clear associative arrays
declare -A gitRepos

