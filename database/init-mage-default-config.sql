# Any SQL files included in the database/backups directory will be
# imported as Vagrant boots up. To best manage expectations, these
# databases should be created in advance with proper user permissions
# so that any code bases configured to work with them will start
# without trouble.
#
# Create a copy of this file as "init-custom.sql" in the database directory
# and add any additional SQL commands that should run on startup. Most likely
# these will be similar to the following - with CREATE DATABASE and GRANT ALL,
# but it can be any command.
#
USE mage;








INSERT INTO `customgrid_grid` (`grid_id`, `type`, `module_name`, `controller_name`, `block_type`, `rewriting_class_name`, `block_id`, `max_attribute_column_id`, `max_custom_column_id`, `default_page`, `default_limit`, `default_sort`, `default_dir`, `default_filter`, `disabled`, `default_page_behaviour`, `default_limit_behaviour`, `default_sort_behaviour`, `default_dir_behaviour`, `default_filter_behaviour`) VALUES
(2,	'product',	'admin',	'catalog_product',	'adminhtml/catalog_product_grid',	'Wsu_Storeuser_Block_Rewrite_AdminCatalogProductGrid',	'productGrid',	1,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	'other',	'customgrid',	'custom_grid',	'customgrid/custom_grid_grid',	NULL,	'BLCG_CustomGridGrid',	0,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL);

INSERT INTO `customgrid_grid_column` (`column_id`, `grid_id`, `id`, `index`, `width`, `align`, `header`, `order`, `origin`, `is_visible`, `is_system`, `missing`, `store_id`, `renderer_type`, `renderer_params`, `allow_edit`, `profile_id`, `custom_params`) VALUES
(6,	2,	'massaction',	'entity_id',	'',	'center',	'',	10,	'grid',	1,	1,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(7,	2,	'entity_id',	'entity_id',	'50px',	'left',	'ID',	30,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(8,	2,	'name',	'name',	'',	'left',	'Name',	40,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(9,	2,	'type',	'type_id',	'60px',	'left',	'Type',	50,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(10,	2,	'set_name',	'attribute_set_id',	'100px',	'left',	'Attrib. Set Name',	60,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(11,	2,	'sku',	'sku',	'80px',	'left',	'SKU',	70,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(12,	2,	'price',	'price',	'80px',	'center',	'Price',	80,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(13,	2,	'qty',	'qty',	'65px',	'center',	'Qty',	90,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(14,	2,	'visibility',	'visibility',	'70px',	'left',	'Visibility',	100,	'grid',	0,	0,	0,	NULL,	NULL,	NULL,	0,	NULL,	NULL),
(15,	2,	'status',	'status',	'70px',	'center',	'Status',	110,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(16,	2,	'action',	'stores',	'50px',	'left',	'Action',	120,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(17,	2,	'entity_type_id',	'entity_type_id',	'',	'left',	'Entity Type Id',	130,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(18,	2,	'created_at',	'created_at',	'',	'left',	'Created At',	140,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(19,	2,	'updated_at',	'updated_at',	'',	'left',	'Updated At',	150,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(20,	2,	'has_options',	'has_options',	'',	'left',	'Has Options',	160,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(21,	2,	'required_options',	'required_options',	'',	'left',	'Required Options',	170,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(22,	2,	'websites',	'websites',	'100px',	'left',	'Websites',	180,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(65,	2,	'_blcg_attribute_column_1',	'image',	'85px',	'left',	'',	20,	'attribute',	1,	0,	0,	NULL,	NULL,	NULL,	0,	NULL,	NULL),
(66,	5,	'massaction',	'grid_id',	NULL,	'center',	NULL,	10,	'grid',	1,	1,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(67,	5,	'block_type',	'block_type',	NULL,	'left',	'Block Type',	20,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(68,	5,	'type',	'type',	NULL,	'left',	'Type',	30,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(69,	5,	'rewriting_class_name',	'rewriting_class_name',	NULL,	'left',	'Rewriting Class',	40,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(70,	5,	'module_name',	'module_name',	NULL,	'left',	'Module Name',	50,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(71,	5,	'controller_name',	'controller_name',	NULL,	'left',	'Controller Name',	60,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(72,	5,	'block_id',	'block_id',	NULL,	'left',	'Block ID',	70,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(73,	5,	'disabled',	'disabled',	NULL,	'left',	'Disabled',	80,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(74,	5,	'action',	'id',	'120px',	'left',	'Actions',	90,	'grid',	1,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(75,	5,	'max_attribute_column_id',	'max_attribute_column_id',	'',	'left',	'Max Attribute Column Id',	100,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(76,	5,	'max_custom_column_id',	'max_custom_column_id',	'',	'left',	'Max Custom Column Id',	110,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(77,	5,	'default_page',	'default_page',	'',	'left',	'Default Page',	120,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(78,	5,	'default_limit',	'default_limit',	'',	'left',	'Default Limit',	130,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(79,	5,	'default_sort',	'default_sort',	'',	'left',	'Default Sort',	140,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(80,	5,	'default_dir',	'default_dir',	'',	'left',	'Default Dir',	150,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(81,	5,	'default_filter',	'default_filter',	'',	'left',	'Default Filter',	160,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(82,	5,	'default_page_behaviour',	'default_page_behaviour',	'',	'left',	'Default Page Behaviour',	170,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(83,	5,	'default_limit_behaviour',	'default_limit_behaviour',	'',	'left',	'Default Limit Behaviour',	180,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(84,	5,	'default_sort_behaviour',	'default_sort_behaviour',	'',	'left',	'Default Sort Behaviour',	190,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(85,	5,	'default_dir_behaviour',	'default_dir_behaviour',	'',	'left',	'Default Dir Behaviour',	200,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(86,	5,	'default_filter_behaviour',	'default_filter_behaviour',	'',	'left',	'Default Filter Behaviour',	210,	'collection',	0,	0,	0,	NULL,	NULL,	NULL,	1,	NULL,	NULL);
