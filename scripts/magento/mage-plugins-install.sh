#!/bin/bash


cd /srv/www/magento/
./mage download community Motech_DefaultAttributeSet
#./mage download community Clever_CMS
#./mage download community Aschroder_SetStartOrderNumber
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
    [WSUMAGE-networksecurities]=washingtonstateuniversity
    [WSUMAGE-admin-base]=washingtonstateuniversity
    [WSUMAGE-theme-base]=washingtonstateuniversity
    [WSUMAGE-auditing]=washingtonstateuniversity
    [WSUMAGE-structured-data]=washingtonstateuniversity
    [WSUMAGE-iri-gateway]=washingtonstateuniversity
    [WSUMAGE-mediacontroll]=jeremyBass
    [WSUMAGE-Storepartitions]=jeremyBass
    [mailing_services]=jeremyBass
    [eventTickets]=jeremyBass 
    #[sitemaps]=jeremyBass
    [webmastertools]=jeremyBass
    [pickupShipping]=jeremyBass
    [AdminQuicklancher]=jeremyBass
    #[dropshippers]=jeremyBass
    [Aoe_FilePicker]=jeremyBass
    [WSUMAGE-pdf-service]=jeremyBass
    [AvS_FastSimpleImport]=jeremyBass      #https://github.com/avstudnitz/AvS_FastSimpleImport
    [Aoe_AsyncCache]=jeremyBass            #https://github.com/fbrnc/Aoe_AsyncCache.git
    [Aoe_ClassPathCache]=AOEmedia          #https://github.com/AOEmedia/Aoe_ClassPathCache.git
    [Aoe_ModelCache]=AOEmedia          #https://github.com/AOEmedia/Aoe_ModelCache
    [Aoe_Profiler]=jeremyBass              #https://github.com/fbrnc/Aoe_Profiler.git
    [Aoe_ManageStores]=jeremyBass          #https://github.com/fbrnc/Aoe_ManageStores.git
    [Aoe_Scheduler]=fbrnc          #https://github.com/fbrnc/Aoe_Scheduler.git
    #[Aoe_Eav]=AOEmedia          #https://github.com/AOEmedia/Aoe_Eav  
    #[Aoe_TemplateHints]=fbrnc
    [mage-enhanced-admin-grids]=jeremyBass #https://github.com/mage-eag/mage-enhanced-admin-grids.git
)
cd /srv/www/magento/
install_tarrepo_list $gitRepos 0 reset_mage
unset gitRepos         #unset and re-declare to clear associative arrays
declare -A gitRepos

