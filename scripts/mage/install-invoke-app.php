<?php
    ob_start();

    header_remove();
    //just as a guide, no real purpose
    echo getcwd() . " (working from)\n";

    //set up the store instance
    require_once "app/Mage.php";
    umask(0);
    $app = Mage::app('default');
    $app->getTranslator()->init('frontend');
    Mage::getSingleton('core/session', array('name' => 'frontend'));
    Mage::registry('isSecureArea'); // acting is if we are in the admin

    Mage::getConfig()->init();

    // switch off error reporting
    error_reporting ( E_ALL & ~ E_NOTICE );
    
    
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

    //time to login as admin
    Mage::app('admin')->setUseSessionInUrl(false);
    Mage::getSingleton('core/session', array('name' => 'adminhtml'));

    $session = Mage::getSingleton('admin/session');
    $user = Mage::getModel('admin/user')->loadByUsername('admin'); // user your admin username
    //adminpass="admin2013"
    //adminuser="admin"
    try {
        $user->login("admin","admin2013");
        $session->renewSession();
        if (Mage::getSingleton('adminhtml/url')->useSecretKey())
            Mage::getSingleton('adminhtml/url')->renewSecretUrls();
        $session->setIsFirstPageAfterLogin(true);
        $session->setUser($user);
        $session->setAcl(Mage::getResourceModel('admin/acl')->loadAcl());
        Mage::dispatchEvent('admin_session_user_login_success', array('user' => $user));   
    } catch (exception $e) {
        print("[ERROR using username & pass:" . $e->getMessage() . "]");
    }

    if ($session->isLoggedIn()) { echo "Logged in \n"; } else{ echo "Not Logged \n"; }
    Mage::app('admin');



    echo "finish invoking the mage app. \n";
    ob_end_flush();// fush all
    exit;// we need to exit so that we close the header and not get a header sent issue.  
?>