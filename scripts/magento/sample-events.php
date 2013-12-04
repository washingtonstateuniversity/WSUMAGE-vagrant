<?php
//it is assumed that this is include where mage::(app); is as well.


$eventsCatId = (isset($eventsCatId) && $eventsCatId>0) ? $eventsCatId : 8;

function getUniqueCode($length = ""){
    $code = md5(uniqid(rand(), true));
    if ($length != "") return substr($code, 0, $length);
    else return $code;
}
$imgAttrIds = array(79,80,81);
$imageGalId = 82;	

    function initFromSkeleton($skeletonId,$set,$stopGroup=null,$stopAttr=null) {
        $groups = Mage::getModel('eav/entity_attribute_group')
            ->getResourceCollection()
            ->setAttributeSetFilter($skeletonId)
            ->load();
    
        $newGroups = filterGroups($set,$groups,$stopGroup,$stopAttr);
        //$set->setGroups($newGroups);
        //return $set;   
        return $newGroups;
    }

    function filterGroups($set,$groups,$stopGroup=null,$stopAttr=null){
        $newGroups = array();
        foreach ($groups as $group) {
            if(!in_array($group->getAttributeGroupName(),$stopGroup)){
                $newGroup = clone $group;
                $newGroup->setId(null)
                    ->setAttributeSetId($set->getId())
                    ->setDefaultId($group->getDefaultId());
            
                $groupAttributesCollection = Mage::getModel('eav/entity_attribute')
                    ->getResourceCollection()
                    ->setAttributeGroupFilter($group->getId())
                    ->load();
            
                $newAttributes = array();
                foreach ($groupAttributesCollection as $attribute) {
                    if(!in_array($attribute->getName(),$stopAttr)){
                        $newAttribute = Mage::getModel('eav/entity_attribute')
                            ->setId($attribute->getId())
                            //->setAttributeGroupId($newGroup->getId())
                            ->setAttributeSetId($set->getId())
                            ->setEntityTypeId($set->getEntityTypeId())
                            ->setSortOrder($attribute->getSortOrder());
                        $newAttributes[] = $newAttribute;
                    }
                }
                $newGroup->setAttributes($newAttributes);
                $newGroups[] = $newGroup;
            }
        }
        return $newGroups;
        //$set->setGroups($newGroups);
        //return $set;       
    }


        /**
         * Create an atribute-set.
         *
         * For reference, see Mage_Adminhtml_Catalog_Product_SetController::saveAction().
         * @
		 * 
		 * 
		 * 
         * @return array|false
         */
        function createAttributeSet($setName, $copyGroupsFromID = -1,$stopGroup=null,$stopAttr=null) {
     
            $setName = trim($setName);
     
            logInfo("Creating attribute-set with name [$setName].");
     
            if($setName == '') {
               // $this->logInfo("Could not create attribute set with an empty name.");
                return false;
            }
     
            //>>>> Create an incomplete version of the desired set.
            $model = Mage::getModel('eav/entity_attribute_set');
     
            // Set the entity type.
            $entityTypeID = Mage::getModel('catalog/product')->getResource()->getTypeId();
            logInfo("Using entity-type-ID ($entityTypeID).");
     
            $model->setEntityTypeId($entityTypeID);
     
            // We don't currently support groups, or more than one level. See
            // Mage_Adminhtml_Catalog_Product_SetController::saveAction().
     
           // $this->logInfo("Creating vanilla attribute-set with name [$setName].");
     
            $model->setAttributeSetName($setName);
     
            // We suspect that this isn't really necessary since we're just
            // initializing new sets with a name and nothing else, but we do
            // this for the purpose of completeness, and of prevention if we
            // should expand in the future.
            $model->validate();
     
            // Create the record.
     
            try {
                $model->save();
            } catch(Exception $ex) {
               // $this->logInfo("Initial attribute-set with name [$setName] could not be saved: " . $ex->getMessage());
                return false;
            }
     
            if(($id = $model->getId()) == false) {
                logInfo("Could not get ID from new vanilla attribute-set with name [$setName].");
                return false;
            }
     
            logInfo("Set ($id) created.");
     
            //<<<<
     
            //>>>> Load the new set with groups (mandatory).
     
            // Attach the same groups from the given set-ID to the new set.
            if($copyGroupsFromID === -1) {
                logInfo("Cloning group configuration from existing set with ID ($copyGroupsFromID).");
               
               //$copyGroupsFromID = Mage::getModel(’catalog/product’)->getResource()->getEntityType()->getDefaultAttributeSetId(); 
                
                //$attributeSetName = "Default"; // put your own attribute set name
                //$attribute_set = Mage::getModel("eav/entity_attribute_set")->getCollection();
                //$attribute_set->addFieldToFilter("attribute_set_name", $attributeSetName)->getFirstItem();
                //$copyGroupsFromID = $attribute_set->getDefaultAttributeSetId();
            }
            $baseGroups = initFromSkeleton($copyGroupsFromID,$model,$stopGroup,$stopAttr);
            //$baseGroups =  $model->getGroups();
            $modelGroup = Mage::getModel('eav/entity_attribute_group');
            $modelGroup->setAttributeGroupName("Event Details");
            $modelGroup->setAttributeSetId($model->getId());
            $modelGroup->setSortOrder(1);
		
			$modelGroup->setId(null)
				->setAttributeSetId($model->getId())
				->setDefaultId($modelGroup->getDefaultId())
				->setSortOrder(1)
				->setAttributes(array());
			$newGroups[] = $modelGroup;
			
			
            $model->setGroups( array_merge($baseGroups,$newGroups) );
            //$model->initFromSkeleton($copyGroupsFromID);
/*            var_dump($model);
die();  
$baseGroups =  $model->getGroups();

var_dump($baseGroups);
die();            */
            //<<<<
     
            // Save the final version of our set.
            try {
                $model->save();
            } catch(Exception $ex) {
                logInfo("Final attribute-set with name [$setName] could not be saved: " . $ex->getMessage());
                return false;
            }
            if(($groupID = $modelGroup->getId()) == false) {
                logInfo("Could not get ID from new group [$groupName].");
                return false;
            }
     
            logInfo("Created attribute-set with ID ($id) and default-group with ID ($groupID).");
     
            return array(
                            'SetID'     => $id,
                            'GroupID'   => $groupID,
                        );
        }
     
        /**
         * Create an attribute.
         *
         * For reference, see Mage_Adminhtml_Catalog_Product_AttributeController::saveAction().
         * @lableText : string -
		 * @attributeCode : string -
		 * @values : string|-1 -
		 * @productTypes : string|-1 - A CSV like "simple, grouped, configurable, virtual, bundle, downloadable, giftcard"
		 * @setInfo : array|-1 -
		 * 
         * @return int|false
         */
        function createAttribute($labelText, $attributeCode, $values = -1, $productTypes = -1, $setInfo = -1) {
     
            $labelText = trim($labelText);
            $attributeCode = trim($attributeCode);
     
            if($labelText == '' || $attributeCode == '') {
                logInfo("Can't import the attribute with an empty label or code.  LABEL= [$labelText]  CODE= [$attributeCode]");
                return false;
            }
     
            if($values === -1) {
                $values = array();
            }
     
            if($productTypes === -1) {
                $productTypes = array();
            }
     
            if($setInfo !== -1 && (isset($setInfo['SetID']) == false || isset($setInfo['GroupID']) == false)) {
                logInfo("Please provide both the set-ID and the group-ID of the attribute-set if you'd like to subscribe to one.");
                return false;
            }
     
            logInfo("Creating attribute [$labelText] with code [$attributeCode].");
     
            //>>>> Build the data structure that will define the attribute. See
            //     Mage_Adminhtml_Catalog_Product_AttributeController::saveAction().
     
            $data = array(
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
                            'is_comparable'                 => '1',
                            'is_used_for_promo_rules'       => '0',
                            'is_html_allowed_on_front'      => '1',
                            'is_visible_on_front'           => '0',
                            'used_in_product_listing'       => '0',
                            'used_for_sort_by'              => '0',
                            'is_configurable'               => '0',
                            'is_filterable'                 => '0',
                            'is_filterable_in_search'       => '0',
                            'backend_type'                  => 'varchar',
                            'default_value'                 => '',
                        );
     
            // Now, overlay the incoming values on to the defaults.
            foreach($values as $key => $newValue) {
                if(isset($data[$key]) == false) {
                    logInfo("Attribute feature [$key] is not valid.");
                    return false;
                } else {
                    $data[$key] = $newValue;
                }
            }
            // Valid product types: simple, grouped, configurable, virtual, bundle, downloadable, giftcard
            $data['apply_to']       = $productTypes;
            $data['attribute_code'] = $attributeCode;
            $data['frontend_label'] = array(
                                                0 => $labelText,
                                                1 => '',
                                                3 => '',
                                                2 => '',
                                                4 => '',
                                            );

            $model = Mage::getModel('catalog/resource_eav_attribute');
     
            $model->addData($data);
     
            if($setInfo !== -1) {
                $model->setAttributeSetId($setInfo['SetID']);
                $model->setAttributeGroupId($setInfo['GroupID']);
            }
     
            $entityTypeID = Mage::getModel('eav/entity')->setType('catalog_product')->getTypeId();
            $model->setEntityTypeId($entityTypeID);
     
            $model->setIsUserDefined(1);

            try {
                $model->save();
            }
            catch(Exception $ex) {
                logInfo("Attribute [$labelText] could not be saved: " . $ex->getMessage());
                return false;
            }
     
            $id = $model->getId();
     
            logInfo("Attribute [$labelText] has been saved as ID ($id).");
     
            return $id;
        }
		$runID="";
        $setInfo = createAttributeSet("Events".$runid,"9",
                                      array('Gift Options','Recurring Profile'),
                                      array('enable_googlecheckout','weight','manufacturer',
                                            'color','msrp_enabled','msrp_display_actual_price_type','msrp')
                                     );
        createAttribute("Event start","eventstartdate".$runid, array(
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

        createAttribute("Event end","eventenddate".$runid, array(
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
			
        createAttribute("Opponent","opponent".$runid, array(
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
        createAttribute("Away Game","awaygame".$runid, array(
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
    $data = array(
        array(
            'sku' => 'event_'.getUniqueCode(20),
            '_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
            'product_type' => 'main product',
            '_attribute_set' => 'Events'.$runid,
            //'attribute_set_id' => 74,
            '_product_websites' => 'eventstore',
            'name' => "Event ".getUniqueCode(2),
            'price' => 14.99,
            //'special_price' => 0.90,
            //'cost' => 0.50,
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
            //'weight' => 0,
            'status' => 1,
            'visibility' => 4,
            'tax_class_id' => 2,
            'qty' => 50,
            'is_in_stock' => 1,
            'enable_googlecheckout' => '0',
            'gift_message_available' => '0',
            'url_key' => strtolower(getUniqueCode(20)),
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
            'sku' => 'event_'.getUniqueCode(20),
            '_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
            'product_type' => 'main product',
            '_attribute_set' => 'Events'.$runid,
            //'attribute_set_id' => 74,
            '_product_websites' => 'eventstore',
            'name' => "Event ".getUniqueCode(2),
            'price' =>35.99,
            //'special_price' => 0.90,
            //'cost' => 0.50,
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
            //'weight' => 0,
            'status' => 1,
            'visibility' => 4,
            'tax_class_id' => 2,
            'qty' => 50,
            'is_in_stock' => 1,
            'enable_googlecheckout' => '0',
            'gift_message_available' => '0',
            'url_key' => strtolower(getUniqueCode(20)),
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
            'sku' => 'event_'.getUniqueCode(20),
            '_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
            'product_type' => 'main product',
            '_attribute_set' => 'Events'.$runid,
            //'attribute_set_id' => 74,
            '_product_websites' => 'eventstore',
            'name' => "Event ".getUniqueCode(2),
            'price' =>25.99,
            //'special_price' => 0.90,
            //'cost' => 0.50,
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
            //'weight' => 0,
            'status' => 1,
            'visibility' => 4,
            'tax_class_id' => 2,
            'qty' => 50,
            'is_in_stock' => 1,
            'enable_googlecheckout' => '0',
            'gift_message_available' => '0',
            'url_key' => strtolower(getUniqueCode(20)),
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
            'sku' => 'event_'.getUniqueCode(20),
            '_type' => Wsu_eventTickets_Model_Product_Type::TYPE_CP_PRODUCT,//'simple',
            'product_type' => 'main product',
            '_attribute_set' => 'Events'.$runid,
            //'attribute_set_id' => 74,
            '_product_websites' => 'eventstore',
            'name' => "Event ".getUniqueCode(2),
            'price' =>45.99,
            //'special_price' => 0.90,
            //'cost' => 0.50,
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
            //'weight' => 0,
            'status' => 1,
            'visibility' => 4,
            'tax_class_id' => 2,
            'qty' => 50,
            'is_in_stock' => 1,
            'enable_googlecheckout' => '0',
            'gift_message_available' => '0',
            'url_key' => strtolower(getUniqueCode(20)),
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
    $import
        ->setPartialIndexing(true)
        ->setBehavior(Mage_ImportExport_Model_Import::BEHAVIOR_APPEND)
        ->processProductImport($data);