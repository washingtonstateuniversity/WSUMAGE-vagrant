<?php

//note this is all just free wheel atm and needs to be refactored big time.
//just saying


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

function logInfo($String){
        echo $String."<br/>";
}

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


function moveStoreProducts($website,$store,$rootcat,$children=null){
    if($children==null)$children = Mage::getModel('catalog/category')->getCategories($rootcat);
    foreach ($children as $category) {
        //echo $category->getName();
        $cat_id=$category->getId();
        $category = Mage::getModel('catalog/category')->load($cat_id);
        $collection = $category->getProductCollection();
        foreach ($collection as $product){
            $oldproductId = $product->getId();
            $_product=$product->load($productId);
            $sku = $_product->getSku();
            //echo "--------------------------------\n for ".$sku.' old webids:'.implode(',',$_product->getWebsiteIds()).' && storeid:'.$oldproductId." \n";
            try{
                $_product->setWebsiteIds(array($website)); //assigning website ID
                $_product->setStoreId($store);
                $_product->save();
            }catch (Exception $e) {
               echo  'failed on sku:: ',$sku,"\n",$e->getMessage(),"\n";
            }
            //$newproductId = $_product->getId();
            //echo 'new webids:'.implode(',',$_product->getWebsiteIds()).' && storeid:'.$newproductId."\n";
        }
        $childrenCats = Mage::getModel('catalog/category')->getCategories($cat_id);
        if( count($childrenCats)>0){ moveStoreProducts($website,$site,$cat_id,$childrenCats); }
    }
}

function make_store($categoryName,$site,$store,$view,$url="",$movingcat=-1){
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
		if($movingcat>0){
			$category = Mage::getModel( 'catalog/category' )->load($movingcat);
			Mage::unregister('category');
			Mage::unregister('current_category');
			Mage::register('category', $category);
			Mage::register('current_category', $category);
			$category->move($rcatId);
		}

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
		$sotercode=$view['code'];
        $store = Mage::getModel('core/store');
        $store->setCode($sotercode)
            ->setWebsiteId($storeGroup->getWebsiteId())
            ->setGroupId($storeGroup->getId())
            ->setName($view['name'])
            ->setIsActive(1)
            ->save();
		
		$storeid = $store->getId();
		moveStoreProducts($webid,$storeid,$rcatId);
		$cmsPageData = array(
			'title' => $site['name'],
			'root_template' => 'one_column',
			'meta_keywords' => 'meta,keywords',
			'meta_description' => 'meta description',
			'identifier' => 'home',
			'content_heading' => '',
			'is_active' => 1,
			'stores' => array($storeid),//available for all store views
			'content' => '<div class="col-left side-col">
<p class="home-callout"><a href="{{store direct_url="#"}"> <img src="{{storemedia url="/ph_callout_left_top.jpg"}}" alt="" border="0" /> </a></p>
<p class="home-callout"><img src="{{storemedia url="/ph_callout_left_rebel.jpg"}}" alt="" border="0" /></p>
{{block type="tag/popular" template="tag/popular.phtml"}}</div>
<div class="home-spot">
<p class="home-callout"><img src="{{storemedia url="/home_main_callout.jpg"}}" alt="" width="535" border="0" /></p>
<p class="home-callout"><img src="{{storemedia url="/free_shipping_callout.jpg"}}" alt="" width="535" border="0" /></p>
</div>
<h1>Sites in the center</h1>
<p>{{block type="catalog/product" stores_per="5" products_per="2" panles_per="3" template="custom_block/site_list.phtml"}}</p>'
		);
		
		Mage::getModel('cms/page')->setData($cmsPageData)->save();
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
                array('name'=>'General Store'),
                array('code'=>'generalstore','name'=>'base default veiw'),
				'general.store.mage.dev',
				18
              );
$installed_stores['eventstore'] = make_store("Event store root",
                array('code'=>'eventstore','name'=>'Event store'),
                array('name'=>'Events Store'),
                array('code'=>'eventstore','name'=>'base default veiw'),
				'events.store.mage.dev',
				-1
              );
$installed_stores['techstore'] = make_store("Tech store root",
                array('code'=>'techstore','name'=>'Tech store'),
                array('name'=>'Tech Store'),
                array('code'=>'techstore','name'=>'base default veiw'),
				'tech.store.mage.dev',
				13
              );

function createCat($storeCodeId,$rootcatID,$cats=array()){
	foreach($cats as $url=>$catInfo){
		$category = Mage::getModel('catalog/category');
		$category->setStoreId($storeCodeId);
		
			$cat['name'] =$catInfo['name'];
			$cat['path'] = "1/".$rootcatID;
			$cat['description'] = $catInfo['description'];
			$cat['is_active'] = $catInfo['is_active'];
			$cat['is_anchor'] = $catInfo['is_anchor'];
			$cat['page_layout'] = $catInfo['is_anchor'];
			$cat['url_key'] = $url;
			$cat['image'] = $catInfo['image'];
		
		$category->addData($cat);
		$category->save();
		$catsId=$category->getId();
		echo " -> added cat ".$catsId."<br/>";
		if(isset($catInfo['children'])&& !empty($catInfo['children'])){
			echo " MAKING CHILDREN FOR -> added cat ".$catsId."<br/>";
			createCat($storeCodeId,$rootcatID.'/'.$catsId,$catInfo['children']);
		}
	}
}
$storeCodeId = Mage::getModel( "core/store" )->load( "eventstore" )->getId();
$rootcatID = $installed_stores['eventstore'];
echo "creating cat for store ".$storeCodeId;
createCat($storeCodeId,$rootcatID,array(
	"events"=>array(
		'name'=>"Sports",
		'description'=>"Events that are great",
		'is_active'=>1,
		'is_anchor'=>0, //for layered navigation
		'page_layout'=>'two_columns_left',
		'image'=>"custom-category.jpg",
		'children'=>array(
			"football"=>array(
				'name'=>"Football",
				'description'=>"Football",
				'is_active'=>1,
				'is_anchor'=>0, //for layered navigation
				'page_layout'=>'two_columns_left',
				'image'=>"football.jpg",
			),
			"basketball"=>array(
				'name'=>"Basketball",
				'description'=>"Basketball",
				'is_active'=>1,
				'is_anchor'=>0, //for layered navigation
				'page_layout'=>'two_columns_left',
				'image'=>"basketball.jpg",
			)
		)
	),
	"classes"=>array(
		'name'=>"Classes",
		'description'=>"Classes",
		'is_active'=>1,
		'is_anchor'=>0, //for layered navigation
		'page_layout'=>'two_columns_left',
		'image'=>"custom-category.jpg",
		'children'=>array(
			"math"=>array(
				'name'=>"Math",
				'description'=>"Mathing it up",
				'is_active'=>1,
				'is_anchor'=>0, //for layered navigation
				'page_layout'=>'two_columns_left'
			),
			"winemaking"=>array(
				'name'=>"Wine Making",
				'description'=>"Making wine",
				'is_active'=>1,
				'is_anchor'=>0, //for layered navigation
				'page_layout'=>'two_columns_left'
			)
		)
	)
));

$eventsCatId=Mage::getModel('catalog/category')->setStoreId($storeCodeId)->loadByAttribute('url_key', 'football')->getId(); 
echo "added cat ".$eventsCatId."<br/>";

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


