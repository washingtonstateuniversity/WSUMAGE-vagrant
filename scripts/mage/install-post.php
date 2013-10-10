<?php
//just as a guide, no real purpose
echo getcwd() . " (working from)\n";

//set up the store instance
require_once "app/Mage.php";
umask(0);
Mage::app();
Mage::app()->getTranslator()->init('frontend');
Mage::getSingleton('core/session', array('name' => 'frontend'));
Mage::registry('isSecureArea'); // acting is if we are in the admin
Mage::app('admin')->setUseSessionInUrl(false);
Mage::getConfig()->init();
/**
 * Get the resource model
 */
    $resource = Mage::getSingleton('core/resource');
 
/**
 * Retrieve the read connection
 */
$readConnection = $resource->getConnection('core_read');
 
/**
 * Retrieve the write connection
 */
$writeConnection = $resource->getConnection('core_write');

// switch off error reporting
error_reporting ( E_ALL & ~ E_NOTICE );





$changeData = new Mage_Core_Model_Config();

echo "applying default store settings\n";
//pattern
//\((.*?),	'(.*?)',	(.*?),	'(.*?)',	'?(.*?)'?\),
//$changeData->saveConfig('$4', "$5", 'default', 0);
echo " - applying design settings\n";
    $changeData->saveConfig('design/package/name', "wsu_base", 'default', 0);
    $changeData->saveConfig('design/theme/template', "default", 'default', 0);
    $changeData->saveConfig('design/theme/skin', "default", 'default', 0);
    $changeData->saveConfig('design/theme/layout', "default", 'default', 0);
    $changeData->saveConfig('design/theme/default', "default", 'default', 0);
    $changeData->saveConfig('design/theme/locale', "NULL", 'default', 0);
    $changeData->saveConfig('design/package/ua_regexp', "a:1:{s:18:\"_1368718560896_896\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:10:\"enterprise\";}}", 'default', 0);
    $changeData->saveConfig('design/theme/template_ua_regexp', "a:1:{s:18:\"_1368719451167_167\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}", 'default', 0);
    $changeData->saveConfig('design/theme/skin_ua_regexp', "a:1:{s:18:\"_1368719467475_475\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}", 'default', 0);
    $changeData->saveConfig('design/theme/layout_ua_regexp', "a:1:{s:17:\"_1368719469024_24\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}", 'default', 0);
    $changeData->saveConfig('design/theme/default_ua_regexp', "a:1:{s:18:\"_1368719470362_362\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:7:\"mobilev\";}}", 'default', 0);

echo " - applying SEO settings\n";
    $changeData->saveConfig('design/head/default_title', "WSU central shopping center", 'default', 0);
    $changeData->saveConfig('design/head/title_prefix', NULL, 'default', 0);
    $changeData->saveConfig('design/head/title_suffix', NULL, 'default', 0);
    $changeData->saveConfig('design/head/default_description', "the Washington State University Central Store", 'default', 0);
    $changeData->saveConfig('design/head/default_keywords', "Washington State University", 'default', 0);
    $changeData->saveConfig('design/head/default_robots', "INDEX,FOLLOW", 'default', 0);

    $changeData->saveConfig('design/head/includes', NULL, 'default', 0);
    $changeData->saveConfig('design/head/demonotice', "0", 'default', 0);
    $changeData->saveConfig('design/header/logo_src', "images/logo.gif", 'default', 0);
    $changeData->saveConfig('design/header/logo_alt', "WSU central shopping center", 'default', 0);
    $changeData->saveConfig('design/header/welcome', "Get more from your university.  Shop the Coug way.", 'default', 0);
    $changeData->saveConfig('design/footer/copyright', "&copy; 2012 University Web Communications - Jeremy Bass. All Rights Reserved.", 'default', 0);
    $changeData->saveConfig('design/footer/absolute_footer', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/image_size', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/image_imageOpacity', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/image_position', "stretch", 'default', 0);
    $changeData->saveConfig('design/watermark/small_image_size', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/small_image_imageOpacity', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/small_image_position', "stretch", 'default', 0);
    $changeData->saveConfig('design/watermark/thumbnail_size', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/thumbnail_imageOpacity', NULL, 'default', 0);
    $changeData->saveConfig('design/watermark/thumbnail_position', "stretch", 'default', 0);
    $changeData->saveConfig('design/pagination/pagination_frame', "5", 'default', 0);
    $changeData->saveConfig('design/pagination/pagination_frame_skip', NULL, 'default', 0);
    $changeData->saveConfig('design/pagination/anchor_text_for_previous', NULL, 'default', 0);
    $changeData->saveConfig('design/pagination/anchor_text_for_next', NULL, 'default', 0);
    $changeData->saveConfig('design/email/logo_alt', NULL, 'default', 0);




    
echo " - applying General settings\n"; 
echo " • web \n";
echo "   - url \n";
$changeData->saveConfig('web/url/use_store', "0", 'default', 0);
$changeData->saveConfig('web/url/redirect_to_base', "1", 'default', 0);
echo "   - seo \n";
$changeData->saveConfig('web/seo/use_rewrites', "1", 'default', 0);
echo "   - unsecure \n";
$changeData->saveConfig('web/unsecure/base_url', "http://local.mage.dev/", 'default', 0);
echo "   - secure \n";
$changeData->saveConfig('web/secure/base_url', "http://local.mage.dev/", 'default', 0);
$changeData->saveConfig('web/secure/use_in_frontend', "0", 'default', 0);
$changeData->saveConfig('web/secure/use_in_adminhtml', "0", 'default', 0);
$changeData->saveConfig('web/secure/offloader_header', "SSL_OFFLOADED", 'default', 0);
echo "   - default \n";
$changeData->saveConfig('web/default/front', "cms", 'default', 0);
$changeData->saveConfig('web/default/cms_home_page', "home", 'default', 0);
$changeData->saveConfig('web/default/no_route', "cms/index/noRoute", 'default', 0);
$changeData->saveConfig('web/default/cms_no_route', "no-route", 'default', 0);
$changeData->saveConfig('web/default/cms_no_cookies', "enable-cookies", 'default', 0);
$changeData->saveConfig('web/default/show_cms_breadcrumbs', "1", 'default', 0);
echo "   - polls \n";
$changeData->saveConfig('web/polls/poll_check_by_ip', "0", 'default', 0);
echo "   - cookie \n";
$changeData->saveConfig('web/cookie/cookie_lifetime', "3600", 'default', 0);
$changeData->saveConfig('web/cookie/cookie_path', NULL, 'default', 0);
$changeData->saveConfig('web/cookie/cookie_domain', NULL, 'default', 0);
$changeData->saveConfig('web/cookie/cookie_httponly', "1", 'default', 0);
$changeData->saveConfig('web/cookie/cookie_restriction', "0", 'default', 0);
echo "   - session \n";
$changeData->saveConfig('web/session/use_remote_addr', "0", 'default', 0);
$changeData->saveConfig('web/session/use_http_via', "0", 'default', 0);
$changeData->saveConfig('web/session/use_http_x_forwarded_for', "0", 'default', 0);
$changeData->saveConfig('web/session/use_http_user_agent', "0", 'default', 0);
$changeData->saveConfig('web/session/use_frontend_sid', "1", 'default', 0);
echo "   - browser_capabilities \n";
$changeData->saveConfig('web/browser_capabilities/cookies', "1", 'default', 0);
$changeData->saveConfig('web/browser_capabilities/javascript', "1", 'default', 0);

echo " • general \n";
echo "   - locale \n";
$changeData->saveConfig('general/locale/code', "en_US", 'default', 0);
$changeData->saveConfig('general/locale/timezone', "America/Los_Angeles", 'default', 0);
$changeData->saveConfig('general/locale/firstday', "0", 'default', 0);
$changeData->saveConfig('general/locale/weekend', "0,6", 'default', 0);
echo "   - country \n";
$changeData->saveConfig('general/country/default', "US", 'default', 0);
$changeData->saveConfig('general/country/allow', "US", 'default', 0);
$changeData->saveConfig('general/country/optional_zip_countries', "US", 'default', 0);
echo "   - region \n";
$changeData->saveConfig('general/region/display_all', "1", 'default', 0);
$changeData->saveConfig('general/region/state_required', "US", 'default', 0);
echo "   - store_information \n";
$changeData->saveConfig('general/store_information/name', "WSU eCommerce Center", 'default', 0);
$changeData->saveConfig('general/store_information/phone', "NULL", 'default', 0);
$changeData->saveConfig('general/store_information/merchant_country', "US", 'default', 0);
$changeData->saveConfig('general/store_information/merchant_vat_number', "NULL", 'default', 0);
$changeData->saveConfig('general/store_information/address', "NULL", 'default', 0);

echo " • currency \n";
$changeData->saveConfig('currency/options/base', "USD", 'default', 0);
$changeData->saveConfig('currency/options/default', "USD", 'default', 0);
$changeData->saveConfig('currency/options/allow', "USD", 'default', 0);

echo " • admin \n";
$changeData->saveConfig('admin/dashboard/enable_charts', "0", 'default', 0);
$changeData->saveConfig('admin/emails/forgot_email_template', "admin_emails_forgot_email_template", 'default', 0);
$changeData->saveConfig('admin/emails/forgot_email_identity', "general", 'default', 0);
$changeData->saveConfig('admin/emails/password_reset_link_expiration_period', "1", 'default', 0);
$changeData->saveConfig('admin/startup/page', "dashboard", 'default', 0);
$changeData->saveConfig('admin/url/use_custom', "0", 'default', 0);
$changeData->saveConfig('admin/url/use_custom_path', "0", 'default', 0);
$changeData->saveConfig('admin/security/use_form_key', "1", 'default', 0);
$changeData->saveConfig('admin/security/use_case_sensitive_login', "0", 'default', 0);
$changeData->saveConfig('admin/security/session_cookie_lifetime', "NULL", 'default', 0);
$changeData->saveConfig('admin/captcha/enable', "0", 'default', 0);
//$changeData->saveConfig('admin/url/custom', "http://store.admin.wsu.edu/", 'default', 0);//<!----------------------set this up as a predefind for local something
$changeData->saveConfig('admin/basicsettings/active', "1", 'default', 0);
$changeData->saveConfig('admin/general/showallproducts', "0", 'default', 0);
$changeData->saveConfig('admin/general/showallcustomers', "1", 'default', 0);
$changeData->saveConfig('admin/general/allowdelete', "0", 'default', 0);
$changeData->saveConfig('admin/general/allowdelete_perwebsite', "0", 'default', 0);
$changeData->saveConfig('admin/su/enable', "0", 'default', 0);
$changeData->saveConfig('admin/su/email', NULL, 'default', 0);

echo " • dev \n";
$changeData->saveConfig('dev/restrict/allow_ips', NULL, 'default', 0);
$changeData->saveConfig('dev/debug/profiler', "1", 'default', 0);
$changeData->saveConfig('dev/template/allow_symlink', "0", 'default', 0);
$changeData->saveConfig('dev/translate_inline/active', "0", 'default', 0);
$changeData->saveConfig('dev/translate_inline/active_admin', "0", 'default', 0);
$changeData->saveConfig('dev/log/active', "1", 'default', 0);
$changeData->saveConfig('dev/log/file', "system.log", 'default', 0);
$changeData->saveConfig('dev/log/exception_file', "exception.log", 'default', 0);
$changeData->saveConfig('dev/js/merge_files', "1", 'default', 0);
$changeData->saveConfig('dev/css/merge_css_files', "1", 'default', 0);



echo " • system \n";
echo "   - crontab \n";
$changeData->saveConfig('crontab/jobs/log_clean/schedule/cron_expr', NULL, 'default', 0);
$changeData->saveConfig('crontab/jobs/log_clean/run/model', "log/cron::logClean", 'default', 0);

$changeData->saveConfig('system/cron/schedule_generate_every', "15", 'default', 0);
$changeData->saveConfig('system/cron/schedule_ahead_for', "20", 'default', 0);
$changeData->saveConfig('system/cron/schedule_lifetime', "15", 'default', 0);
$changeData->saveConfig('system/cron/history_cleanup_every', "10", 'default', 0);
$changeData->saveConfig('system/cron/history_success_lifetime', "60", 'default', 0);
$changeData->saveConfig('system/cron/history_failure_lifetime', "600", 'default', 0);

$changeData->saveConfig('system/currency/installed', "USD", 'default', 0);

echo "   - logging \n";
$changeData->saveConfig('system/log/clean_after_day', "180", 'default', 0);
$changeData->saveConfig('system/log/enabled', "0", 'default', 0);
$changeData->saveConfig('system/log/time', "00,00,00", 'default', 0);
$changeData->saveConfig('system/log/frequency', "D", 'default', 0);
$changeData->saveConfig('system/log/error_email', NULL, 'default', 0);
$changeData->saveConfig('system/log/error_email_identity', "general", 'default', 0);
$changeData->saveConfig('system/log/error_email_template', "system_log_error_email_template", 'default', 0);




$changeData->saveConfig('system/adminnotification/use_https', "0", 'default', 0);
$changeData->saveConfig('system/adminnotification/frequency', "1", 'default', 0);

$changeData->saveConfig('system/external_page_cache/enabled', "1", 'default', 0);
$changeData->saveConfig('system/external_page_cache/cookie_lifetime', "3600", 'default', 0);
$changeData->saveConfig('system/external_page_cache/control', "zend_page_cache", 'default', 0);

$changeData->saveConfig('system/backup/enabled', "0", 'default', 0);

$changeData->saveConfig('system/media_storage_configuration/media_storage', "0", 'default', 0);
$changeData->saveConfig('system/media_storage_configuration/media_database', "default_setup", 'default', 0);
$changeData->saveConfig('system/media_storage_configuration/configuration_update_time', "3600", 'default', 0);



$changeData->saveConfig('system/aoeasynccache/select_limit', "0", 'default', 0);
$changeData->saveConfig('system/aoeasynccache/scheduler_cron_expr', "*/15 * * * *", 'default', 0);



echo "   - email mailing services \n";
$changeData->saveConfig('system/smtp/disable', "0", 'default', 0);
$changeData->saveConfig('system/smtp/host', "localhost", 'default', 0);
$changeData->saveConfig('system/smtp/port', "25", 'default', 0);
$changeData->saveConfig('system/smtp/set_return_path', "0", 'default', 0);

$changeData->saveConfig('system/googlesettings/email', null, 'default', 0);
$changeData->saveConfig('system/googlesettings/gpassword', null, 'default', 0);

$changeData->saveConfig('system/smtpsettings/smtpsettings', "none", 'default', 0);
$changeData->saveConfig('system/smtpsettings/username', null, 'default', 0);
$changeData->saveConfig('system/smtpsettings/password', null, 'default', 0);
$changeData->saveConfig('system/smtpsettings/host', "mail.wsu.edu", 'default', 0);
$changeData->saveConfig('system/smtpsettings/port', "25", 'default', 0);
$changeData->saveConfig('system/smtpsettings/ssl', "none", 'default', 0);

$changeData->saveConfig('system/mailingservices/option', "smtp", 'default', 0);
$changeData->saveConfig('system/mailingservices/store_addresses', "0", 'default', 0);
$changeData->saveConfig('system/mailingservices/development', "disabled", 'default', 0);
$changeData->saveConfig('system/mailingservices/logenabled', "1", 'default', 0);

$changeData->saveConfig('system/contacts/enabled', "1", 'default', 0);
$changeData->saveConfig('system/contacts/recipient_email', "jeremy.bass@wsu.edu", 'default', 0); //<!------would want to dyno it
$changeData->saveConfig('system/contacts/sender_email_identity', "custom2", 'default', 0);
$changeData->saveConfig('system/contacts/email_template', "contacts_email_email_template", 'default', 0);




echo " - applying Module settings\n";
$changeData->saveConfig('admin/aoe_filepicker/apikey', "Ang5LopT2QEK4xtU91zxnz", 'default', 0);
$changeData->saveConfig('admin/aoe_filepicker/services', "filepicker.SERVICES.BOX,filepicker.SERVICES.COMPUTER,filepicker.SERVICES.DROPBOX,filepicker.SERVICES.FACEBOOK,filepicker.SERVICES.GITHUB,filepicker.SERVICES.GMAIL,filepicker.SERVICES.GOOGLE_DRIVE,filepicker.SERVICES.IMAGE_SEARCH,filepicker.SERVICES.URL,filepicker.SERVICES.WEBCAM", 'default', 0);




//clear the paypal link on front
$changeData->saveConfig('payment/express/checkout/frontend/logo', "", 'default', 0);

$changeData->saveConfig('payment/ccsave/active', "0", 'default', 0);
$changeData->saveConfig('payment/ccsave/title', "Credit Card (saved)", 'default', 0);
$changeData->saveConfig('payment/ccsave/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/ccsave/cctypes', "AE,VI,MC,DI", 'default', 0);
$changeData->saveConfig('payment/ccsave/useccv', "0", 'default', 0);
$changeData->saveConfig('payment/ccsave/centinel', "0", 'default', 0);
$changeData->saveConfig('payment/ccsave/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/ccsave/min_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/ccsave/max_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/ccsave/sort_order', NULL, 'default', 0);

$changeData->saveConfig('payment/banktransfer/active', "0", 'default', 0);
$changeData->saveConfig('payment/banktransfer/title', "Bank Transfer Payment", 'default', 0);
$changeData->saveConfig('payment/banktransfer/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/banktransfer/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/banktransfer/instructions', NULL, 'default', 0);
$changeData->saveConfig('payment/banktransfer/min_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/banktransfer/max_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/banktransfer/sort_order', NULL, 'default', 0);

$changeData->saveConfig('payment/checkmo/active', "1", 'default', 0);
$changeData->saveConfig('payment/checkmo/title', "Check / Money order", 'default', 0);
$changeData->saveConfig('payment/checkmo/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/checkmo/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/checkmo/payable_to', NULL, 'default', 0);
$changeData->saveConfig('payment/checkmo/mailing_address', NULL, 'default', 0);
$changeData->saveConfig('payment/checkmo/min_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/checkmo/max_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/checkmo/sort_order', NULL, 'default', 0);

$changeData->saveConfig('payment/cashondelivery/active', "0", 'default', 0);
$changeData->saveConfig('payment/cashondelivery/title', "Cash On Delivery", 'default', 0);
$changeData->saveConfig('payment/cashondelivery/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/cashondelivery/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/cashondelivery/instructions', NULL, 'default', 0);
$changeData->saveConfig('payment/cashondelivery/min_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/cashondelivery/max_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/cashondelivery/sort_order', NULL, 'default', 0);

$changeData->saveConfig('payment/free/title', "No Payment Information Required", 'default', 0);
$changeData->saveConfig('payment/free/active', "1", 'default', 0);
$changeData->saveConfig('payment/free/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/free/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/free/sort_order', "1", 'default', 0);
$changeData->saveConfig('payment/purchaseorder/active', "0", 'default', 0);
$changeData->saveConfig('payment/purchaseorder/title', "Purchase Order", 'default', 0);

$changeData->saveConfig('payment/purchaseorder/order_status', "pending", 'default', 0);
$changeData->saveConfig('payment/purchaseorder/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/purchaseorder/min_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/purchaseorder/max_order_total', NULL, 'default', 0);
$changeData->saveConfig('payment/purchaseorder/sort_order', NULL, 'default', 0);

$changeData->saveConfig('payment/central_processing/active', "1", 'default', 0);
$changeData->saveConfig('payment/central_processing/title', "Checking out with WSU\'s central payment system", 'default', 0);
$changeData->saveConfig('payment/central_processing/merchant_id', "7aReBr9K1O5VguV2Rm5Ilw==", 'default', 0);
$changeData->saveConfig('payment/central_processing/security_key', "7aReBr9K1O7tpF4Gv0rU7g==", 'default', 0);
$changeData->saveConfig('payment/central_processing/payment_action', "authorize_capture", 'default', 0);
$changeData->saveConfig('payment/central_processing/order_status', "processing", 'default', 0);
$changeData->saveConfig('payment/central_processing/useccv', "0", 'default', 0);
$changeData->saveConfig('payment/central_processing/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/central_processing/test', "1", 'default', 0);
$changeData->saveConfig('payment/central_processing/debug', "1", 'default', 0);
$changeData->saveConfig('payment/central_processing/sort_order', NULL, 'default', 0);
$changeData->saveConfig('payment/central_processing/cctypes', "AE,VI,MC,DI", 'default', 0);
$changeData->saveConfig('payment/central_processing/submit_url', NULL, 'default', 0);

$changeData->saveConfig('payment/centralprocessing/active', "1", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/title', "the payment everyone wants to pay", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/merchant_id', "X6I+UcL6Lk4=", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/security_key', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing/payment_action', "authorize", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/order_status', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing/useccv', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/test', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/debug', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing/submit_url', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing/sort_order', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/active', "1", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/title', "Central processing Checkout", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/merchant_id', "WSUPUBSMISC", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/security_key', "K/wA4xvqJEYlnkDQzZNFlA==", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/payment_action', "authorize", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/order_status', "processing", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/useccv', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/allowspecific', "0", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/test', "1", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/debug', "1", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/submit_url', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/sort_order', NULL, 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/cctypes', "AE,VI,MC,DI", 'default', 0);
$changeData->saveConfig('payment/centralprocessing_express/sandbox_flag', "1", 'default', 0);


$changeData->saveConfig('sharing_tool/general/enabled', "1", 'default', 0);
$changeData->saveConfig('sharing_tool/general/pubid', "mcwsu", 'default', 0);
$changeData->saveConfig('sharing_tool/button_style/button_set', "style_1", 'default', 0);
$changeData->saveConfig('sharing_tool/button_style/custom_button_url', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_exclude', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_compact', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_expanded', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_custom_name', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_custom_url', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/services_custom_icon', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_click', "1", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_delay', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_hover_direction', "0", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_open_windows', "1", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_language', "auto", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_offset_top', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_offset_left', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_header_color', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_header_background', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_cobrand', "Wsu", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_use_css', "1", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_use_addressbook', "0", 'default', 0);
$changeData->saveConfig('sharing_tool/api/ui_508_compliant', "0", 'default', 0);
$changeData->saveConfig('sharing_tool/api/data_track_clickback', "1", 'default', 0);
$changeData->saveConfig('sharing_tool/api/data_ga_tracker', "UA-17815664-1", 'default', 0);
$changeData->saveConfig('sharing_tool/custom_share/custom_url', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/custom_share/custom_title', NULL, 'default', 0);
$changeData->saveConfig('sharing_tool/custom_share/custom_description', NULL, 'default', 0);


/*
$changeData->saveConfig('dcadmin/ldaplogin/host', "directory.ad.wsu.edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/version', "3", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/port', "389", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/tls', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/rootdn', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/rootpassword', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/userdn', "OU=WSU Accounts,dc=ad,dc=wsu,dc=edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/filter', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/cmpattr', "cn", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/passattr', "password", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/attr', "{\"login\":\"cn\",\"firstname\":\"givenname\",\"mail\":\"mail\",\"lastname\":\"sn\"}", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/defaultroleid', "20", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/activeldap', "1", 'default', 0);
*/





$changeData->saveConfig('advanced/modules_disable_output/AddThis_SharingTool', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/BL_CustomGrid', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/DivaCloud_Admin', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Flagbit_ChangeAttributeSet', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Admin', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_AdminNotification', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Api', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Api2', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Authorizenet', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Backup', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Bundle', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Captcha', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Catalog', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_CatalogIndex', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_CatalogInventory', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_CatalogRule', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_CatalogSearch', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Centinel', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Checkout', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Cms', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Compiler', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Connect', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Contacts', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Core', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Cron', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_CurrencySymbol', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Customer', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Cybersource', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Dataflow', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Directory', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Downloadable', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Eav', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_GiftMessage', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_GoogleAnalytics', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_GoogleCheckout', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_ImportExport', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Index', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Install', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Log', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Media', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Newsletter', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Oauth', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Page', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_PageCache', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Paygate', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Payment', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Paypal', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_PaypalUk', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Persistent', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Poll', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_ProductAlert', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Rating', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Reports', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Review', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Rss', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Rule', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Sales', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_SalesRule', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Sendfriend', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Shipping', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Sitemap', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Tag', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Tax', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Usa', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Weee', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Widget', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_Wishlist', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Mage_XmlConnect', "1", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Phoenix_Moneybookers', "0", 'default', 0);
$changeData->saveConfig('advanced/modules_disable_output/Wsu_Centralprocessing', "0", 'default', 0);

$changeData->saveConfig('payment/centralprocessing_express/trantype', "WEBOBC", 'default', 0);

$changeData->saveConfig('customer/account_share/scope', "0", 'default', 0);
$changeData->saveConfig('customer/online_customers/online_minutes_interval', NULL, 'default', 0);
$changeData->saveConfig('customer/create_account/auto_group_assign', "0", 'default', 0);
$changeData->saveConfig('customer/create_account/default_group', "1", 'default', 0);
$changeData->saveConfig('customer/create_account/viv_disable_auto_group_assign_default', "0", 'default', 0);
$changeData->saveConfig('customer/create_account/vat_frontend_visibility', "0", 'default', 0);
$changeData->saveConfig('customer/create_account/email_domain', "example.com", 'default', 0);
$changeData->saveConfig('customer/create_account/email_template', "customer_create_account_email_template", 'default', 0);
$changeData->saveConfig('customer/create_account/email_identity', "general", 'default', 0);
$changeData->saveConfig('customer/create_account/confirm', "0", 'default', 0);
$changeData->saveConfig('customer/create_account/email_confirmation_template', "customer_create_account_email_confirmation_template", 'default', 0);
$changeData->saveConfig('customer/create_account/email_confirmed_template', "customer_create_account_email_confirmed_template", 'default', 0);
$changeData->saveConfig('customer/create_account/generate_human_friendly_id', "0", 'default', 0);
$changeData->saveConfig('customer/password/forgot_email_template', "customer_password_forgot_email_template", 'default', 0);
$changeData->saveConfig('customer/password/remind_email_template', "customer_password_remind_email_template", 'default', 0);
$changeData->saveConfig('customer/password/forgot_email_identity', "support", 'default', 0);
$changeData->saveConfig('customer/password/reset_link_expiration_period', "1", 'default', 0);
$changeData->saveConfig('customer/address/street_lines', "2", 'default', 0);
$changeData->saveConfig('customer/address/prefix_show', NULL, 'default', 0);
$changeData->saveConfig('customer/address/prefix_options', NULL, 'default', 0);
$changeData->saveConfig('customer/address/middlename_show', "0", 'default', 0);
$changeData->saveConfig('customer/address/suffix_show', NULL, 'default', 0);
$changeData->saveConfig('customer/address/suffix_options', NULL, 'default', 0);
$changeData->saveConfig('customer/address/dob_show', NULL, 'default', 0);
$changeData->saveConfig('customer/address/taxvat_show', NULL, 'default', 0);
$changeData->saveConfig('customer/address/gender_show', NULL, 'default', 0);
$changeData->saveConfig('customer/startup/redirect_dashboard', "1", 'default', 0);
$changeData->saveConfig('customer/address_templates/text', "{{depend prefix}}{{var prefix}} {{/depend}}{{var firstname}} {{depend middlename}}{{var middlename}} {{/depend}}{{var lastname}}{{depend suffix}} {{var suffix}}{{/depend}}
{{depend company}}{{var company}}{{/depend}}
{{if street1}}{{var street1}}
{{/if}}
{{depend street2}}{{var street2}}{{/depend}}
{{depend street3}}{{var street3}}{{/depend}}
{{depend street4}}{{var street4}}{{/depend}}
{{if city}}{{var city}},  {{/if}}{{if region}}{{var region}}, {{/if}}{{if postcode}}{{var postcode}}{{/if}}
{{var country}}
T: {{var telephone}}
{{depend fax}}F: {{var fax}}{{/depend}}
{{depend vat_id}}VAT: {{var vat_id}}{{/depend}}", 'default', 0);
$changeData->saveConfig('customer/address_templates/oneline', "{{depend prefix}}{{var prefix}} {{/depend}}{{var firstname}} {{depend middlename}}{{var middlename}} {{/depend}}{{var lastname}}{{depend suffix}} {{var suffix}}{{/depend}}, {{var street}}, {{var city}}, {{var region}} {{var postcode}}, {{var country}}", 'default', 0);
$changeData->saveConfig('customer/address_templates/html', "{{depend prefix}}{{var prefix}} {{/depend}}{{var firstname}} {{depend middlename}}{{var middlename}} {{/depend}}{{var lastname}}{{depend suffix}} {{var suffix}}{{/depend}}<br/>
{{depend company}}{{var company}}<br />{{/depend}}
{{if street1}}{{var street1}}<br />{{/if}}
{{depend street2}}{{var street2}}<br />{{/depend}}
{{depend street3}}{{var street3}}<br />{{/depend}}
{{depend street4}}{{var street4}}<br />{{/depend}}
{{if city}}{{var city}},  {{/if}}{{if region}}{{var region}}, {{/if}}{{if postcode}}{{var postcode}}{{/if}}<br/>
{{var country}}<br/>
{{depend telephone}}T: {{var telephone}}{{/depend}}
{{depend fax}}<br/>F: {{var fax}}{{/depend}}
{{depend vat_id}}<br/>VAT: {{var vat_id}}{{/depend}}", 'default', 0);
$changeData->saveConfig('customer/address_templates/pdf', "{{depend prefix}}{{var prefix}} {{/depend}}{{var firstname}} {{depend middlename}}{{var middlename}} {{/depend}}{{var lastname}}{{depend suffix}} {{var suffix}}{{/depend}}|
{{depend company}}{{var company}}|{{/depend}}
{{if street1}}{{var street1}}
{{/if}}
{{depend street2}}{{var street2}}|{{/depend}}
{{depend street3}}{{var street3}}|{{/depend}}
{{depend street4}}{{var street4}}|{{/depend}}
{{if city}}{{var city}},|{{/if}}
{{if region}}{{var region}}, {{/if}}{{if postcode}}{{var postcode}}{{/if}}|
{{var country}}|
{{depend telephone}}T: {{var telephone}}{{/depend}}|
{{depend fax}}<br/>F: {{var fax}}{{/depend}}|
{{depend vat_id}}<br/>VAT: {{var vat_id}}{{/depend}}|", 'default', 0);
$changeData->saveConfig('customer/address_templates/js_template', "#{prefix} #{firstname} #{middlename} #{lastname} #{suffix}<br/>#{company}<br/>#{street0}<br/>#{street1}<br/>#{street2}<br/>#{street3}<br/>#{city}, #{region}, #{postcode}<br/>#{country_id}<br/>T: #{telephone}<br/>F: #{fax}<br/>VAT: #{vat_id}", 'default', 0);
$changeData->saveConfig('customer/captcha/enable', "0", 'default', 0);
/*$changeData->saveConfig('semantium/basicsettings/active', "1", 'default', 0);
$changeData->saveConfig('semantium/basicsettings/setfooterlink', "1", 'default', 0);
$changeData->saveConfig('semantium/businessinformation/legalname', NULL, 'default', 0);
$changeData->saveConfig('semantium/address/streetaddress', NULL, 'default', 0);
$changeData->saveConfig('semantium/address/postalcode', NULL, 'default', 0);
$changeData->saveConfig('semantium/address/locality', NULL, 'default', 0);
$changeData->saveConfig('semantium/address/countryname', "US", 'default', 0);
$changeData->saveConfig('semantium/address/tel', NULL, 'default', 0);
$changeData->saveConfig('semantium/address/email', NULL, 'default', 0);
$changeData->saveConfig('semantium/pos_address/haspos', "0", 'default', 0);
$changeData->saveConfig('semantium/pos_address/usefromcompany', "1", 'default', 0);
$changeData->saveConfig('semantium/pos_address/streetaddress', NULL, 'default', 0);
$changeData->saveConfig('semantium/pos_address/postalcode', NULL, 'default', 0);
$changeData->saveConfig('semantium/pos_address/locality', NULL, 'default', 0);
$changeData->saveConfig('semantium/pos_address/countryname', "US", 'default', 0);
$changeData->saveConfig('semantium/pos_address/tel', NULL, 'default', 0);
$changeData->saveConfig('semantium/pos_address/email', NULL, 'default', 0);
$changeData->saveConfig('semantium/offering/description', NULL, 'default', 0);
$changeData->saveConfig('semantium/customer_types/enduser', "1", 'default', 0);
$changeData->saveConfig('semantium/customer_types/business', "0", 'default', 0);
$changeData->saveConfig('semantium/customer_types/reseller', "0", 'default', 0);
$changeData->saveConfig('semantium/customer_types/publicinstitution', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/byBankTransferInAdvance', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/byInvoice', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/cash', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/checkinadvance', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/cod', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/directdebit', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/googleCheckout', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/paypal', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/americanexpress', "1", 'default', 0);
$changeData->saveConfig('semantium/payment_options/dinersclub', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/discover', "1", 'default', 0);
$changeData->saveConfig('semantium/payment_options/jcb', "0", 'default', 0);
$changeData->saveConfig('semantium/payment_options/mastercard', "1", 'default', 0);
$changeData->saveConfig('semantium/payment_options/visa', "1", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/dhl', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/ups', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/mail', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/fedex', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/directdownload', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/pickup', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/vendorfleet', "0", 'default', 0);
$changeData->saveConfig('semantium/delivery_methods/freight', "0", 'default', 0);
$changeData->saveConfig('semantium/strongid/strongid_type', "ean13", 'default', 0);
$changeData->saveConfig('semantium/strongid/strongid_db', "0", 'default', 0);
$changeData->saveConfig('semantium/strongid/strongid_dba', "sku", 'default', 0);
$changeData->saveConfig('semantium/validity/valid_period', "3", 'default', 0);
$changeData->saveConfig('semantium/validity/valid_through', "tomorrow", 'default', 0);*/

/*
$changeData->saveConfig('gatracking/analytics/active', "1", 'default', 0);
$changeData->saveConfig('gatracking/analytics/account', "UA-41835019-1", 'default', 0);
$changeData->saveConfig('gatracking/analytics/account', "student", 'default', 0);
$changeData->saveConfig('gatracking/analytics/account', "test", 'default', 0);
*/

$changeData->saveConfig('wsustructureddata/basicsettings/active', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/businessinformation/legalname', "WSU", 'default', 0);
$changeData->saveConfig('wsustructureddata/address/streetaddress', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/address/postalcode', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/address/locality', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/address/countryname', "US", 'default', 0);
$changeData->saveConfig('wsustructureddata/address/tel', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/address/email', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/haspos', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/usefromcompany', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/streetaddress', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/postalcode', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/locality', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/countryname', "US", 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/tel', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/pos_address/email', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/offering/description', NULL, 'default', 0);
$changeData->saveConfig('wsustructureddata/customer_types/enduser', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/customer_types/business', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/customer_types/reseller', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/customer_types/publicinstitution', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/byBankTransferInAdvance', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/byInvoice', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/cash', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/checkinadvance', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/cod', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/directdebit', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/googleCheckout', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/paypal', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/americanexpress', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/dinersclub', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/discover', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/jcb', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/mastercard', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/payment_options/visa', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/dhl', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/ups', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/mail', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/fedex', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/directdownload', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/pickup', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/vendorfleet', "0", 'default', 0);
$changeData->saveConfig('wsustructureddata/delivery_methods/freight', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/strongid/strongid_type', "ean13", 'default', 0);
$changeData->saveConfig('wsustructureddata/strongid/strongid_db', "1", 'default', 0);
$changeData->saveConfig('wsustructureddata/strongid/strongid_dba', "sku", 'default', 0);
$changeData->saveConfig('wsustructureddata/validity/valid_period', "3", 'default', 0);
$changeData->saveConfig('wsustructureddata/validity/valid_through', "tomorrow", 'default', 0);

/*$changeData->saveConfig('gatracking/analytics/fb_og_sitename', NULL, 'default', 0);
$changeData->saveConfig('gatracking/analytics/fb_og_type', NULL, 'default', 0);
$changeData->saveConfig('gatracking/analytics/fb_og_iamge', NULL, 'default', 0);
$changeData->saveConfig('gatracking/analytics/msvalidate', "25281AAA75FA29A69B3D49C6FFB3B204", 'default', 0);
$changeData->saveConfig('gatracking/analytics/ga_verifi', "J5p8Yx8Li1yaN41fhtvl1zzJVoApq1t67l1WdFNff4c", 'default', 0);
$changeData->saveConfig('gatracking/analytics/fb_admin', "494506507310454", 'default', 0);
$changeData->saveConfig('gatracking/analytics/ms_apikey', "e2bea98618ce4f8a97d0c87062d6fc9a", 'default', 0);
$changeData->saveConfig('gatracking/analytics/fb_og_title', NULL, 'default', 0);
*/
$changeData->saveConfig('webmastertools/analytics/active', "1", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/account', "UA-41835019-1", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/ga_verifi', "J5p8Yx8Li1yaN41fhtvl1zzJVoApq1t67l1WdFNff4c", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/msvalidate', "25281AAA75FA29A69B3D49C6FFB3B204", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/ms_apikey', "e2bea98618ce4f8a97d0c87062d6fc9a", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/fb_admin', "494506507310454", 'default', 0);
$changeData->saveConfig('webmastertools/analytics/fb_og_iamge', NULL, 'default', 0);
$changeData->saveConfig('webmastertools/analytics/fb_og_sitename', NULL, 'default', 0);
$changeData->saveConfig('webmastertools/analytics/fb_og_title', NULL, 'default', 0);
$changeData->saveConfig('webmastertools/analytics/fb_og_type', NULL, 'default', 0);







$changeData->saveConfig('dcadmin/ldaplogin/testusername', "test.user", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/testuserpass', "G123raffe()", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/adminatuocreate', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchingusername', "AD\up_search", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchinguserpass', "CougsrGreat!1", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchhost', "dc05-pul.ad.wsu.edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchversion', "3", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchport', "3268", 'default', 0);
$changeData->saveConfig('dcadmin/ldaplogin/searchtls', "0", 'default', 0);

$changeData->saveConfig('dcadmin/ldapadminlogin/activeldap', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/allow_bypass', "1", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/host', "directory.ad.wsu.edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/version', "3", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/port', "389", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/tls', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/rootdn', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/rootpassword', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/userdn', "OU=WSU Accounts,dc=ad,dc=wsu,dc=edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/filter', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/cmpattr', "cn", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/passattr', "password", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/attr', "{\"login\":\"cn\",\"firstname\":\"givenname\",\"mail\":\"mail\",\"lastname\":\"sn\"}", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/defaultroleid', "20", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/autocreate', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/testusername', "test.user", 'default', 0);
$changeData->saveConfig('dcadmin/ldapadminlogin/testuserpass', "G123raffe()", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/activeldap', "1", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/restricttoldap', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/host', "directory.ad.wsu.edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/version', "3", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/port', "389", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/tls', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/rootdn', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/rootpassword', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/userdn', "OU=WSU Accounts,dc=ad,dc=wsu,dc=edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/filter', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/cmpattr', "cn", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/passattr', "password", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/attr', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/defaultroleid', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/autocreate', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/testusername', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapcustomerlogin/testuserpass', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/activeldap', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/host', "directory.ad.wsu.edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/version', "3", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/port', "389", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/tls', "0", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/rootdn', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/rootpassword', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/userdn', "OU=WSU Accounts,dc=ad,dc=wsu,dc=edu", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/filter', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/cmpattr', "cn", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/passattr', "password", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/attr', "{\"login\":\"cn\",\"firstname\":\"givenname\",\"mail\":\"mail\",\"lastname\":\"sn\"}", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/defaultroleid', NULL, 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/searcherusername', "AD\up_search", 'default', 0);
$changeData->saveConfig('dcadmin/ldapsearcher/searcheruserpass', "CougsrGreat!1", 'default', 0);







function make_store($categoryName,$site,$store,$view){
    //#adding a root cat for the new store we will create
    // Create category object
    $category = Mage::getModel('catalog/category');
    $category->setStoreId(0); // No store is assigned to this category
    
    $rootCategory['name'] = $categoryName;
    $rootCategory['path'] = "1"; // this is the catgeory path - 1 for root category
    $rootCategory['display_mode'] = "PRODUCTS";
    $rootCategory['is_active'] = 1;
    
    $category->addData($rootCategory);
    $rootCategoryId=0;
    try {
        $category->save();
        $rootCategoryId = $category->getId();
    }
        catch (Exception $e){
        echo $e->getMessage();
    }
    if($rootCategoryId>0){
    //#addWebsite
        /** @var $website Mage_Core_Model_Website */
        $website = Mage::getModel('core/website');
        $website->setCode($site['code'])
            ->setName($site['name'])
            ->save();
    
    //#addStoreGroup
        /** @var $storeGroup Mage_Core_Model_Store_Group */
        $storeGroup = Mage::getModel('core/store_group');
        $storeGroup->setWebsiteId($website->getId())
            ->setName($store['name'])
            ->setRootCategoryId($rootCategoryId)
            ->save();
    
    //#addStore
        /** @var $store Mage_Core_Model_Store */
        $store = Mage::getModel('core/store');
        $store->setCode($view['code'])
            ->setWebsiteId($storeGroup->getWebsiteId())
            ->setGroupId($storeGroup->getId())
            ->setName($view['name'])
            ->setIsActive(1)
            ->save();
    }
    return $rootCategoryId;
}
echo "Applying the default multi-store setup\n";
$installed_stores = array();
$installed_stores['studentstore'] = make_store("Student store root",
                array('code'=>'studentstore','name'=>'Student store'),
                array('name'=>'Student Store'),
                array('code'=>'studentstore','name'=>'base default veiw')
              );
$installed_stores['teststore'] = make_store("Test store root",
                array('code'=>'teststore','name'=>'Test store'),
                array('name'=>'Test Store'),
                array('code'=>'teststore','name'=>'base default veiw')
              );



// let us refresh the cache
try {
    $allTypes = Mage::app()->useCache();
    foreach($allTypes as $type => $blah) {
      Mage::app()->getCacheInstance()->cleanType($type);
    }
} catch (Exception $e) {
    // do something
    error_log($e->getMessage());
}


$types = Mage::app()->getCacheInstance()->getTypes();
try {
    echo "Cleaning data cache... \n";
    flush();
    foreach ($types as $type => $data) {
        echo "Removing $type ... ";
        echo Mage::app()->getCacheInstance()->clean($data["tags"]) ? "[OK]" : "[ERROR]";
        echo "\n";
    }
} catch (exception $e) {
    die("[ERROR:" . $e->getMessage() . "]");
}

echo "\n";

try {
    echo "Cleaning stored cache... ";
    flush();
    echo Mage::app()->getCacheInstance()->clean() ? "[OK]" : "[ERROR]";
    echo "\n\n";
} catch (exception $e) {
    die("[ERROR:" . $e->getMessage() . "]");
}










    $modules = Mage::getConfig()->getNode('modules')->children();
    $modulesArray = (array)$modules;
    echo "Test modules";
    if(isset($modulesArray['Aoe_AsyncCache'])) {
        echo "AsyncCache exists.";
        $tableName = $resource->getTableName('asynccache');
         
        /**
         * if prefix was 'mage_' then the below statement
         * would print out mage_catalog_product_entity
         */
        echo "known as ".$tableName;
    } else {
        echo "AsyncCachedoesn't exist.";
    }   













/*


edit	1	default	0	web/seo/use_rewrites	1
edit	2	default	0	admin/dashboard/enable_charts	0
edit	3	default	0	web/unsecure/base_url	http://local.mage.dev/
edit	4	default	0	web/secure/base_url	http://local.mage.dev/
edit	5	default	0	general/locale/code	en_US
edit	6	default	0	general/locale/timezone	America/Los_Angeles
edit	7	default	0	currency/options/base	USD
edit	8	default	0	currency/options/default	USD
edit	9	default	0	currency/options/allow	USD
edit	10	default	0	general/region/display_all	1
edit	11	default	0	general/region/state_required	AT,CA,CH,DE,EE,ES,FI,FR,LT,LV,RO,US
edit	12	default	0	design/package/name	wsu_base
edit	13	default	0	design/theme/template	default
edit	14	default	0	design/theme/skin	default
edit	15	default	0	design/theme/layout	default
edit	16	default	0	design/theme/default	default
edit	17	default	0	design/package/ua_regexp	a:1:{s:18:"_1368718560896_896";a:2:{s:6:"regexp";s:7:"WSU_DEV";s:5:"value";s:10:"enterprise";}}
edit	18	default	0	design/theme/template_ua_regexp	a:1:{s:18:"_1368719451167_167";a:2:{s:6:"regexp";s:7:"WSU_DEV";s:5:"value";s:6:"mobile";}}
edit	19	default	0	design/theme/skin_ua_regexp	a:1:{s:18:"_1368719467475_475";a:2:{s:6:"regexp";s:7:"WSU_DEV";s:5:"value";s:6:"mobile";}}
edit	20	default	0	design/theme/layout_ua_regexp	a:1:{s:17:"_1368719469024_24";a:2:{s:6:"regexp";s:7:"WSU_DEV";s:5:"value";s:6:"mobile";}}
edit	21	default	0	design/theme/default_ua_regexp	a:1:{s:18:"_1368719470362_362";a:2:{s:6:"regexp";s:7:"WSU_DEV";s:5:"value";s:7:"mobilev";}}
edit	22	default	0	design/theme/locale	NULL
edit	23	default	0	design/head/default_title	Magento Commerce
edit	24	default	0	design/head/title_prefix	NULL
edit	25	default	0	design/head/title_suffix	NULL
edit	26	default	0	design/head/default_description	Default Description
edit	27	default	0	design/head/default_keywords	Magento, Varien, E-commerce
edit	28	default	0	design/head/default_robots	INDEX,FOLLOW
edit	29	default	0	design/head/includes	NULL
edit	30	default	0	design/head/demonotice	0
edit	31	default	0	design/header/logo_src	images/logo.gif
edit	32	default	0	design/header/logo_alt	Magento Commerce
edit	33	default	0	design/header/welcome	Default welcome msg!
edit	34	default	0	design/footer/copyright	&copy; 2012 Magento Demo Store. All Rights Reserved.
edit	35	default	0	design/footer/absolute_footer	NULL
edit	36	default	0	design/watermark/image_size	NULL
edit	37	default	0	design/watermark/image_imageOpacity	NULL
edit	38	default	0	design/watermark/image_position	stretch
edit	39	default	0	design/watermark/small_image_size	NULL
edit	40	default	0	design/watermark/small_image_imageOpacity	NULL
edit	41	default	0	design/watermark/small_image_position	stretch
edit	42	default	0	design/watermark/thumbnail_size	NULL
edit	43	default	0	design/watermark/thumbnail_imageOpacity	NULL
edit	44	default	0	design/watermark/thumbnail_position	stretch
edit	45	default	0	design/pagination/pagination_frame	5
edit	46	default	0	design/pagination/pagination_frame_skip	NULL
edit	47	default	0	design/pagination/anchor_text_for_previous	NULL
edit	48	default	0	design/pagination/anchor_text_for_next	NULL
edit	49	default	0	design/email/logo_alt	NULL


*/
