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
#INSERT INTO `core_config_data` (`config_id`, `scope`, `scope_id`, `path`, `value`) VALUES
#(43,	'default',	0,	'design/theme/template',	'wsu_base'),
#(45,	'default',	0,	'design/theme/skin',	'wsu_base'),
#(47,	'default',	0,	'design/theme/layout',	'wsu_base'),
#(49,	'default',	0,	'design/theme/default',	'wsu_base'),


#UPDATE `core_config_data` SET    value = 'wsu_base'
#WHERE  path = 'design/theme/template' AND `scope_id`=0 AND `scope`='default'

#UPDATE `core_config_data` SET    value = 'wsu_base'
#WHERE  path = 'design/theme/skin' AND `scope_id`=0 AND `scope`='default'

#UPDATE `core_config_data` SET    value = 'wsu_base'
#WHERE  path = 'design/theme/layout' AND `scope_id`=0 AND `scope`='default'

#UPDATE `core_config_data` SET    value = 'wsu_base'
#WHERE  path = 'design/theme/default' AND `scope_id`=0 AND `scope`='default'


SET @paths = 'design/theme/template,design/theme/skin,design/theme/layout,design/theme/default';# -- paths to use
UPDATE `core_config_data` 
SET value = 'wsu_base' 
WHERE `scope_id`=0 
    AND `scope`='default' 
    AND FIND_IN_SET(`path`, @paths);








#
#(41,	'default',	0,	'design/package/ua_regexp',	'a:1:{s:18:\"_1368718560896_896\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:10:\"enterprise\";}}'),
#(44,	'default',	0,	'design/theme/template_ua_regexp',	'a:1:{s:18:\"_1368719451167_167\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}'),
#(46,	'default',	0,	'design/theme/skin_ua_regexp',	'a:1:{s:18:\"_1368719467475_475\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}'),
#(48,	'default',	0,	'design/theme/layout_ua_regexp',	'a:1:{s:17:\"_1368719469024_24\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:6:\"mobile\";}}'),
#(50,	'default',	0,	'design/theme/default_ua_regexp',	'a:1:{s:18:\"_1368719470362_362\";a:2:{s:6:\"regexp\";s:7:\"WSU_DEV\";s:5:\"value\";s:7:\"mobilev\";}}');



