#!/bin/bash

	# PHPUnit
	#
	# Check that PHPUnit, Mockery, and Hamcrest are all successfully installed. If
	# not, then Composer should be given another shot at it. Versions for these
	# packages are controlled in the `/srv/config/phpunit-composer.json` file.
	if [ ! -d /usr/local/src/vvv-phpunit ]
	then
		echo "Installing PHPUnit, Hamcrest and Mockery..."
		mkdir -p /usr/local/src/vvv-phpunit
		cp /srv/config/phpunit-composer.json /usr/local/src/vvv-phpunit/composer.json
		sh -c "cd /usr/local/src/vvv-phpunit && composer install"
	else
		cd /usr/local/src/vvv-phpunit
		if composer show -i | grep -q 'mockery' ; then echo "Mockery installed" ; else vvvphpunit_update=1; fi
		if composer show -i | grep -q 'phpunit' ; then echo "PHPUnit installed" ; else vvvphpunit_update=1; fi
		if composer show -i | grep -q 'hamcrest'; then echo "Hamcrest installed"; else vvvphpunit_update=1; fi
		cd ~/
	fi

	if [ "$vvvphpunit_update" = 1 ]
	then
		echo "Update PHPUnit, Hamcrest and Mockery..."
		cp /srv/config/phpunit-composer.json /usr/local/src/vvv-phpunit/composer.json
		sh -c "cd /usr/local/src/vvv-phpunit && composer update"
	fi