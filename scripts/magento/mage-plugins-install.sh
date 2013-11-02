#!/bin/bash

cd /srv/www/

#./mage download community Flagbit_ChangeAttributeSet
#./mage download community BL_CustomGrid
#./mage download community Ewall_Autocrosssell
#./mage download community FireGento_Pdf
#./mage download community Custom_PDF_Invoice_Layout
#./mage download community ASchroder_SMTPPro
#./mage download community Semantium_MSemanticBasic
#./mage install community Semantium_MSemanticBasic
#./mage install community Ewall_Autocrosssell
#./mage install community FireGento_Pdf

#./mage install community Flagbit_ChangeAttributeSet
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
    [WSUMAGE-admin-base]=washingtonstateuniversity
    [WSUMAGE-theme-base]=washingtonstateuniversity
    [eventTickets]=jeremyBass 
    [WSUMAGE-structured-data]=washingtonstateuniversity
    [Storeuser]=jeremyBass
    [sitemaps]=jeremyBass
    [webmastertools]=jeremyBass
    [WSUMAGE-ldap]=washingtonstateuniversity
    [pickupShipping]=jeremyBass
    [AdminQuicklancher]=jeremyBass
    #[dropshippers]=jeremyBass
    [Aoe_FilePicker]=jeremyBass
    [mailing_services]=jeremyBass
    [WSUMAGE-iri-gateway]=washingtonstateuniversity
    [WSUMAGE-pdf-service]=jeremyBass
    #[custom_pdf_invoice]=jeremyBass
    [Aoe_Profiler]=jeremyBass              #https://github.com/fbrnc/Aoe_Profiler.git
    [Aoe_ManageStores]=jeremyBass          #https://github.com/fbrnc/Aoe_ManageStores.git
    #[Aoe_LayoutConditions]=jeremyBass      #https://github.com/fbrnc/Aoe_LayoutConditions.git
    [Aoe_AsyncCache]=jeremyBass            #https://github.com/fbrnc/Aoe_AsyncCache.git
    #[Aoe_ApiLog]=jeremyBass                #https://github.com/fbrnc/Aoe_ApiLog.git
    #[Inchoo_Logger]=ajzele                 #https://github.com/ajzele/Inchoo_Logger.git
    [Aoe_ClassPathCache]=AOEmedia          #https://github.com/AOEmedia/Aoe_ClassPathCache.git
    [mage-enhanced-admin-grids]=jeremyBass #https://github.com/mage-eag/mage-enhanced-admin-grids.git
)
cd /srv/www/magento/
install_tarrepo_list $gitRepos 0 reset_mage
unset gitRepos         #unset and re-declare to clear associative arrays
declare -A gitRepos

