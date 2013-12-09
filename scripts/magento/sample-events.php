<?php
//it is assumed that this is include where mage::(app); is as well.
function getUniqueCode($length = ""){
    return Mage::helper('storeutilities/utilities')->getUniqueCode($length);
}



$websiteCodes = 'eventstore';//array('eventstore');
$storeCodes = 'eventstore';//array('eventstore');
/* */

echo $websiteCodes.'::websiteCodes'."\n";
echo $storeCodes.'::storeCodes'."\n";



$storeCodeId = Mage::getModel( "core/store" )->load($storeCodes)->getId();
$rootcatID = Mage::app()->getStore($storeCodeId)->getRootCategoryId();
echo $storeCodeId.'::storeCodeId'."\n";
echo $rootcatID.'::rootcatID'."\n";

echo "creating cat for store ".$storeCodeId;
Mage::helper('storeutilities/utilities')->createCat($storeCodeId,$rootcatID,array(
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


$imgAttrIds = array(79,80,81);
$imageGalId = 82;	
$defaultAttrSetId = Mage::getModel('catalog/product')->getDefaultAttributeSetId();
echo $defaultAttrSetId.'::defaultAttrSetId'."\n";
$runid="";//getUniqueCode(20);//
$setInfo = Mage::helper('storeutilities/utilities')
					->createAttributeSet("Events".$runid,
										  $defaultAttrSetId,
										  array('Gift Options','Recurring Profile'),
										  array('enable_googlecheckout','weight','manufacturer','color','msrp_enabled','msrp_display_actual_price_type','msrp')
					 );
var_dump($setInfo);echo '::setInfo'."\n";

					 
Mage::helper('storeutilities/utilities')->createAttribute("Event start","eventstartdate".$runid, array(
		'is_global'                     => '0',
		'frontend_input'                => 'date',
		'default_value_text'            => '',
		'default_value_yesno'           => '0',
		'default_value_date'            => '',
		'default_value_textarea'        => '',
		'is_unique'                     => '0',
		'is_required'                   => '0',
		'frontend_class'                => '',
		'is_searchable'                 => '1',
		'is_visible_in_advanced_search' => '1',
		'is_comparable'                 => '0',
		'is_used_for_promo_rules'       => '0',
		'is_html_allowed_on_front'      => '1',
		'is_visible_on_front'           => '0',
		'used_in_product_listing'       => '1',
		'used_for_sort_by'              => '1',
		'is_configurable'               => '0',
		'is_filterable'                 => '0',
		'is_filterable_in_search'       => '0',
		'backend_type'                  => 'datetime',
		'default_value'                 => ''
	),array("event"), $setInfo);

Mage::helper('storeutilities/utilities')->createAttribute("Event end","eventenddate".$runid, array(
		'is_global'                     => '0',
		'frontend_input'                => 'date',
		'default_value_text'            => '',
		'default_value_yesno'           => '0',
		'default_value_date'            => '',
		'default_value_textarea'        => '',
		'is_unique'                     => '0',
		'is_required'                   => '0',
		'frontend_class'                => '',
		'is_searchable'                 => '1',
		'is_visible_in_advanced_search' => '1',
		'is_comparable'                 => '0',
		'is_used_for_promo_rules'       => '0',
		'is_html_allowed_on_front'      => '1',
		'is_visible_on_front'           => '0',
		'used_in_product_listing'       => '0',
		'used_for_sort_by'              => '1',
		'is_configurable'               => '0',
		'is_filterable'                 => '0',
		'is_filterable_in_search'       => '0',
		'backend_type'                  => 'datetime',
		'default_value'                 => ''
	),array("event"), $setInfo);

Mage::helper('storeutilities/utilities')->createAttribute("Opponent","opponent".$runid, array(
		'is_global'                     => '0',
		'frontend_input'                => 'text',
		'default_value_text'            => '',
		'default_value_yesno'           => '0',
		'default_value_date'            => '',
		'default_value_textarea'        => '',
		'is_unique'                     => '0',
		'is_required'                   => '0',
		'frontend_class'                => '',
		'is_searchable'                 => '1',
		'is_visible_in_advanced_search' => '1',
		'is_comparable'                 => '0',
		'is_used_for_promo_rules'       => '0',
		'is_html_allowed_on_front'      => '1',
		'is_visible_on_front'           => '0',
		'used_in_product_listing'       => '0',
		'used_for_sort_by'              => '1',
		'is_configurable'               => '0',
		'is_filterable'                 => '0',
		'is_filterable_in_search'       => '0',
		'backend_type'                  => 'text',
		'default_value'                 => ''
	),array("event"), $setInfo);
Mage::helper('storeutilities/utilities')->createAttribute("Away Game","awaygame".$runid, array(
		'is_global'                     => '0',
		'frontend_input'                => 'boolean',
		'default_value_text'            => '',
		'default_value_yesno'           => '0',
		'default_value_date'            => '',
		'default_value_textarea'        => '',
		'is_unique'                     => '0',
		'is_required'                   => '0',
		'frontend_class'                => '',
		'is_searchable'                 => '1',
		'is_visible_in_advanced_search' => '1',
		'is_comparable'                 => '0',
		'is_used_for_promo_rules'       => '0',
		'is_html_allowed_on_front'      => '1',
		'is_visible_on_front'           => '0',
		'used_in_product_listing'       => '1',
		'used_for_sort_by'              => '1',
		'is_configurable'               => '0',
		'is_filterable'                 => '0',
		'is_filterable_in_search'       => '0',
		'backend_type'                  => 'int',
		'default_value'                 => ''
	),array("event"), $setInfo);			
	


$media_gallery_id = Mage::getSingleton('catalog/product')->getResource()->getAttribute('media_gallery') ->getAttributeId();
echo $media_gallery_id.'::media_gallery_id'."\n";
echo $websiteCodes.'::websiteCodes'."\n";


$data = array(
	array(
		'sku' => 'event_'.getUniqueCode(10),
		'_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
		'product_type' => 'main product',
		'_attribute_set' => 'Events'.$runid,
		//'attribute_set_id' => 74,
		'_product_websites' => $websiteCodes,
		'website' => $websiteCodes,
		'name' => "Event ".getUniqueCode(2),
		'price' => 14.99,
		'_category' => $eventsCatId,
		'description' => 'Default',
		'short_description' => 'Default',
		'eventstartdate'.$runid =>'12/13/2013',
		'eventenddate'.$runid =>'12/13/2013',
		'opponent'.$runid=>'OSU',
		'awaygame'.$runid=>1,
		'meta_title' => 'Default',
		'meta_description' => 'Default',
		'meta_keywords' => 'Default',
		'status' => 1,
		'visibility' => 4,
		'tax_class_id' => 2,
		'qty' => 50,
		'is_in_stock' => 1,
		'enable_googlecheckout' => '0',
		'gift_message_available' => '0',
		'url_key' => strtolower(getUniqueCode(10)),
		'media_gallery' => $media_gallery_id,
		"_media_attribute_id" => $media_gallery_id,
		"_media_lable" =>"Game Day",
		"_media_position" => 1,
		"_media_is_disabled" => 0,
		"_media_image" => "http://images.wsu.edu/images/examples/surfinfootball.jpg",
		'image' => basename("http://images.wsu.edu/images/examples/surfinfootball.jpg"),
		'small_image' => basename("http://images.wsu.edu/images/examples/surfinfootball.jpg"),
		'thumbnail' => basename("http://images.wsu.edu/images/examples/surfinfootball.jpg"),
	),
	array(
		'sku' => 'event_'.getUniqueCode(10),
		'_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
		'product_type' => 'main product',
		'_attribute_set' => 'Events'.$runid,
		//'attribute_set_id' => 74,
		'_product_websites' => $websiteCodes,
		'website' => $websiteCodeId,
		'name' => "Event ".getUniqueCode(2),
		'price' =>35.99,
		'_category' => $eventsCatId,
		'description' => 'Default',
		'short_description' => 'Default',
		'eventstartdate'.$runid =>'12/21/2013',
		'eventenddate'.$runid =>'12/21/2013',
		'opponent'.$runid=>'OSU',
		'awaygame'.$runid=>1,
		'meta_title' => 'Default',
		'meta_description' => 'Default',
		'meta_keywords' => 'Default',
		'status' => 1,
		'visibility' => 4,
		'tax_class_id' => 2,
		'qty' => 50,
		'is_in_stock' => 1,
		'enable_googlecheckout' => '0',
		'gift_message_available' => '0',
		'url_key' => strtolower(getUniqueCode(10)),
		'media_gallery' => $media_gallery_id,
		"_media_attribute_id" => $media_gallery_id,
		"_media_lable" =>"Game Day",
		"_media_position" => 1,
		"_media_is_disabled" => 0,
		"_media_image" => "http://images.wsu.edu/images/examples/soundingoff.jpg",
		'image' => basename("http://images.wsu.edu/images/examples/soundingoff.jpg"),
		'small_image' => basename("http://images.wsu.edu/images/examples/soundingoff.jpg"),
		'thumbnail' => basename("http://images.wsu.edu/images/examples/soundingoff.jpg"),
	),
	
	array(
		'sku' => 'event_'.getUniqueCode(10),
		'_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
		'product_type' => 'main product',
		'_attribute_set' => 'Events'.$runid,
		//'attribute_set_id' => 74,
		'_product_websites' => $websiteCodes,
		'website' => $websiteCodeId,
		'name' => "Event ".getUniqueCode(2),
		'price' =>25.99,
		'_category' => $eventsCatId,
		'description' => 'Default',
		'short_description' => 'Default',
		'eventstartdate'.$runid =>'12/30/2013',
		'eventenddate'.$runid =>'12/30/2013',
		'opponent'.$runid=>'IDHO',
		'awaygame'.$runid=>0,
		'meta_title' => 'Default',
		'meta_description' => 'Default',
		'meta_keywords' => 'Default',
		'status' => 1,
		'visibility' => 4,
		'tax_class_id' => 2,
		'qty' => 50,
		'is_in_stock' => 1,
		'enable_googlecheckout' => '0',
		'gift_message_available' => '0',
		'url_key' => strtolower(getUniqueCode(10)),
		'media_gallery' => $media_gallery_id,
		"_media_attribute_id" => $media_gallery_id,
		"_media_lable" =>"Game Day",
		"_media_position" => 1,
		"_media_is_disabled" => 0,
		"_media_image" => "http://images.wsu.edu/images/examples/rootin.jpg",
		'image' => basename("http://images.wsu.edu/images/examples/rootin.jpg"),
		'small_image' => basename("http://images.wsu.edu/images/examples/rootin.jpg"),
		'thumbnail' => basename("http://images.wsu.edu/images/examples/rootin.jpg"),
	),
	
	array(
		'sku' => 'event_'.getUniqueCode(10),
		'_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
		'product_type' => 'main product',
		'_attribute_set' => 'Events'.$runid,
		//'attribute_set_id' => 74,
		'_product_websites' => $websiteCodes,
		'website' => $websiteCodeId,
		'name' => "Event ".getUniqueCode(2),
		'price' =>45.99,
		'_category' => $eventsCatId,
		'description' => 'Default',
		'short_description' => 'Default',
		'eventstartdate'.$runid =>'1/21/2014',
		'eventenddate'.$runid =>'1/21/2014',
		'opponent'.$runid=>'UTAH',
		'awaygame'.$runid=>1,
		'meta_title' => 'Default',
		'meta_description' => 'Default',
		'meta_keywords' => 'Default',
		'status' => 1,
		'visibility' => 4,
		'tax_class_id' => 2,
		'qty' => 50,
		'is_in_stock' => 1,
		'enable_googlecheckout' => '0',
		'gift_message_available' => '0',
		'url_key' => strtolower(getUniqueCode(10)),
		'media_gallery' => $media_gallery_id,
		"_media_attribute_id" => $media_gallery_id,
		"_media_lable" =>"Game Day",
		"_media_position" => 1,
		"_media_is_disabled" => 0,
		"_media_image" => "http://football-weekends.wsu.edu/Content/images/Landing05.jpg",
		'image' => basename("http://football-weekends.wsu.edu/Content/images/Landing05.jpg"),
		'small_image' => basename("http://football-weekends.wsu.edu/Content/images/Landing05.jpg"),
		'thumbnail' => basename("http://football-weekends.wsu.edu/Content/images/Landing05.jpg"),
	),
	
	
	// add more products here
);

$import = Mage::getModel('fastsimpleimport/import');
/*
var_dump($data);
$import
	->setPartialIndexing(true)
	->setBehavior(Mage_ImportExport_Model_Import::BEHAVIOR_APPEND)
	->dryrunProductImport($data);

*/
$import
	->setPartialIndexing(true)
	->setBehavior(Mage_ImportExport_Model_Import::BEHAVIOR_APPEND)
	->processProductImport($data);
