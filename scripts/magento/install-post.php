<?php
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
$settingsarray = csv_to_array('../scripts/magento/settings.config');
foreach($settingsarray as $item){
    $val =  $item['value']=="NULL"?NULL:$item['value'];
    $cDat->saveConfig($item['path'], $val, 'default', 0);
}
$cDat->saveConfig('admin/url/custom', 'http://store.admin.mage.dev/', 'default', 0);


function moveStoreProducts($site,$rootcat){
		$children = Mage::getModel('catalog/category')->getCategories($rootcat);
		foreach ($children as $category) {
			//echo $category->getName();
			$category = Mage::getModel('catalog/category')->load($category->getId());
			$collection = $category->getProductCollection();
			foreach ($collection as $product){
				$productId = $product->getId();
				$_product=$product->load($productId);
				var_dump($_product->getWebsiteIds());
				echo 'old webids<br/>storeid:<br/>'.$_product->getStoreId().'<br/>';
				
				$_product->setWebsiteIds(array($site)); //assigning website ID
				$_product->setStoreId($site);
				$_product->save();
				var_dump($_product->getWebsiteIds());
				echo 'new webids<br/>storeid:<br/>'.$_product->getStoreId().'<br/>';
				//copy the details of the products to new store
				//$newProduct = Mage::getModel('catalog/product')
				//->setStoreId(0) //0=default store id, copy default values. give the id of the store whose values you want to copy to new store
				//->load($productId)
				//new store id
				//->save();
			}
			$childrenCats = Mage::getModel('catalog/category')->getCategories($category->getId());
			if( count($childrenCats)>0){ moveStoreProducts($site,$category->getId()); }
		}
}

function make_store($categoryName,$site,$store,$view,$url="",$movingcat){
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
		$category = Mage::getModel( 'catalog/category' )->load($movingcat);
		Mage::unregister('category');
		Mage::unregister('current_category');
		Mage::register('category', $category);
		Mage::register('current_category', $category);
		$category->move($rcatId);


    //#addWebsite
        /** @var $website Mage_Core_Model_Website */
        $website = Mage::getModel('core/website');
        $website->setCode($site['code'])
            ->setName($site['name'])
            ->save();
    	$webid = $website->getId();
    //#addStoreGroup
        /** @var $storeGroup Mage_Core_Model_Store_Group */
        $storeGroup = Mage::getModel('core/store_group');
        $storeGroup->setWebsiteId($website->getId())
            ->setName($store['name'])
            ->setRootCategoryId($rcatId)
            ->save();
		$cDat = new Mage_Core_Model_Config();
		$cDat->saveConfig('web/unsecure/base_url', "http://".$url.'/', 'websites', $webid);
		$cDat->saveConfig('web/secure/base_url', "https://".$url.'/', 'websites', $webid);
    //#addStore
        /** @var $store Mage_Core_Model_Store */
        $store = Mage::getModel('core/store');
        $store->setCode($view['code'])
            ->setWebsiteId($storeGroup->getWebsiteId())
            ->setGroupId($storeGroup->getId())
            ->setName($view['name'])
            ->setIsActive(1)
            ->save();
			
		$storeid = $store->getId();
		moveStoreProducts($storeid,$rcatId);
		
    }
    return $rcatId;
}
echo "Applying the default multi-store setup\n";
$installed_stores = array();
$installed_stores['studentstore'] = make_store("Student store root",
                array('code'=>'studentstore','name'=>'Student store'),
                array('name'=>'Student Store'),
                array('code'=>'studentstore','name'=>'base default veiw'),
				'student.store.mage.dev',
				10
              );
$installed_stores['generalstore'] = make_store("General store root",
                array('code'=>'generalstore','name'=>'General store'),
                array('name'=>'Test Store'),
                array('code'=>'generalstore','name'=>'base default veiw'),
				'general.store.mage.dev',
				18
              );
$installed_stores['eventstore'] = make_store("Event store root",
                array('code'=>'eventstore','name'=>'Test store'),
                array('name'=>'Events Store'),
                array('code'=>'eventstore','name'=>'base default veiw'),
				'events.store.mage.dev',
				13
              );

/*
    $categoryIds = array(21,22,23);//category ids whose products you want to assign

*/




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


