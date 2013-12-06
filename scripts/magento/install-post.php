<?php

//note this is all just free wheel atm and needs to be refactored big time.
//just saying
//also it requires that you have the storeutilities ext installed.

/*
NOTE that this requires
	:: storeutilities
	:: fastsimpleimport
*/



//just as a guide, no real purpose
echo getcwd() . " (working from)\n";
$argv = $_SERVER['argv'];

parse_str($argv[2], $output);

//exit();die();
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
 
$cDat = new Mage_Core_Model_Config();
$settingsarray = Mage::helper('storeutilities/utilities')->csv_to_array('../scripts/magento/settings.config');
foreach($settingsarray as $item){
    $val =  $item['value']=="NULL"?NULL:$item['value'];
    $cDat->saveConfig($item['path'], $val, 'default', 0);
}
$cDat->saveConfig('admin/url/custom', 'http://store.admin.mage.dev/', 'default', 0);
 
echo "Applying the default multi-store setup\n";

Mage::helper('storeutilities/utilities')->make_store("Student store root",
                array('code'=>'studentstore','name'=>'Student store'),
                array('name'=>'Student Store'),
                array('code'=>'studentstore','name'=>'base default veiw'),
				'student.store.mage.dev',
				10
              );
Mage::helper('storeutilities/utilities')->make_store("General store root",
                array('code'=>'generalstore','name'=>'General store'),
                array('name'=>'General Store'),
                array('code'=>'generalstore','name'=>'base default veiw'),
				'general.store.mage.dev',
				18
              );
Mage::helper('storeutilities/utilities')->make_store("Tech store root",
                array('code'=>'techstore','name'=>'Tech store'),
                array('name'=>'Tech Store'),
                array('code'=>'techstore','name'=>'base default veiw'),
				'tech.store.mage.dev',
				13
              );

include_once('sample-events.php');

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


