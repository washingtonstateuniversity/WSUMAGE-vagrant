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
    $adminSession = Mage::getSingleton('admin/session');
    $adminSession->unsetAll();
    $adminSession->getCookie()->delete($adminSession->getSessionName());

    if ($session->isLoggedIn()) { echo "Logged in \n"; } else{ echo "Not Logged \n"; }
    Mage::app('admin');
    echo "finished invoking the mage app. \n";
    ob_end_flush();// fush all
    exit;// we need to exit so that we close the header and not get a header sent issue.  
?>