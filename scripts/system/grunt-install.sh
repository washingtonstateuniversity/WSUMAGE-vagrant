#!/bin/bash

	# Grunt
	#
	# Install or Update Grunt based on gurrent state.  Updates are direct
	# from NPM
	if [ ! -d /usr/lib/node_modules/grunt-cli  ]
	then
		echo "Installing Grunt CLI"
		npm install -g grunt-cli
	else
		echo "Updating Grunt CLI"
		npm update -g grunt-cli
	fi