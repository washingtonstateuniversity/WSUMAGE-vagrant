#!/bin/bash
last_location="/"
current_location="/"


#base of tracking with rew/forw/stop/etc
set_location(){
    $last_location=$current_location
    $current_location=pwd
}
prevous_location(){
    return $last_location
}


#check to see if there is network connection
has_network(){
    # Capture a basic ping result to Google's primary DNS server to determine if
    # outside access is available to us. If this does not reply after 2 attempts,
    # we try one of Level3's DNS servers as well. If neither of these IPs replies to
    # a ping, then we'll skip a few things further in provisioning rather than
    # creating a bunch of errors.
    
    ping_result=`ping -c 2 8.8.4.4 2>&1`
    if [[ $ping_result != *bytes?from* ]]
    then
        ping_result=`ping -c 2 4.2.2.2 2>&1`
    fi
	[[ $ping_result == *bytes?from* ]] && return 1 || return 0
}
