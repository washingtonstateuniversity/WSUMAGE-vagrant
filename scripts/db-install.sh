#!/bin/bash

cd /srv/www/
# MySQL gives us an error if we restart a non running service, which
# happens after a `vagrant halt`. Check to see if it's running before
# deciding whether to start or restart.
exists_mysql=`service mysql status`
if [ "mysql stop/waiting" == "$exists_mysql" ]
then
	echo "service mysql start"
	service mysql start
else
	echo "service mysql restart"
	service mysql restart
fi

# IMPORT SQL
#
# Create the databases (unique to system) that will be imported with
# the mysqldump files located in database/backups/
if [ -f /srv/database/init-custom.sql ]
then
	mysql -u root -pblank < /srv/database/init-custom.sql | echo -e "\nInitial custom MySQL scripting..."
else
	echo -e "\nNo custom MySQL scripting found in database/init-custom.sql, skipping..."
fi

# Setup MySQL by importing an init file that creates necessary
# users and databases that our vagrant setup relies on.
mysql -u root -pblank < /srv/database/init.sql | echo "Initial MySQL prep..."

# Process each mysqldump SQL file in database/backups to import
# an initial data set for MySQL.
/srv/database/import-sql.sh
