<?php
//just as a guide, no real purpose
echo getcwd() . " (working from)\n";
$argv = $_SERVER['argv'];

parse_str($argv[2], $output);

var_dump($output);
echo $output["adminuser"];

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





function csv_to_array($filename='', $delimiter=','){
     if(!file_exists($filename) || !is_readable($filename))
         return FALSE;

     $header = NULL;
     $data = array();
     if (($handle = fopen($filename, 'r')) !== FALSE){
         while (($row = fgetcsv($handle,1000, $delimiter)) !== FALSE){
             if(!$header){
                 $header = $row;
			 }else{
                 $data[] = array_combine($header, $row);
			 }
         }
         fclose($handle);
     }
     return $data;
 }

$cDat = new Mage_Core_Model_Config();
$settingsarray = csv_to_array('../scripts/mage/settings.config');
var_dump($settingsarray);
foreach($settingsarray as $item){
    $val =  $item['value']=="NULL"?NULL:$item['value'];
    $cDat->saveConfig($item['path'], $val, 'default', 0);
}



function make_store($categoryName,$site,$store,$view){
    //#adding a root cat for the new store we will create
    // Create category object
    $category = Mage::getModel('catalog/category');
    $category->setStoreId(0); // No store is assigned to this category
    
    $rcat['name'] = $categoryName;
    $rcat['path'] = "1"; // this is the catgeory path - 1 for root category
    $rcat['display_mode'] = "PRODUCTS";
    $rcat['is_active'] = 1;
    
    $category->addData($rcat);
    $rcatId=0;
    try {
        $category->save();
        $rcatId = $category->getId();
    }
        catch (Exception $e){
        echo $e->getMessage();
    }
    if($rcatId>0){
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
            ->setRootCategoryId($rcatId)
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
    return $rcatId;
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

