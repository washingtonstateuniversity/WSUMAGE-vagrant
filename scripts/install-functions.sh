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

#check to see if there is network connection
checkpagkages(){
    echo "Check for apt packages to install..."
    apt_package_check_list=$1
    apt_package_install_list=()
    
    # Loop through each of our packages that should be installed on the system. If
    # not yet installed, it should be added to the array of packages to install.
    for pkg in "${apt_package_check_list[@]}"
    do
        package_version=`dpkg -s $pkg 2>&1 | grep 'Version:' | cut -d " " -f 2`
        if [[ $package_version != "" ]]
        then
            space_count=`expr 20 - "${#pkg}"` #11
            pack_space_count=`expr 30 - "${#package_version}"`
            real_space=`expr ${space_count} + ${pack_space_count} + ${#package_version}`
            printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
        else
            echo " *" $pkg [not installed]
            apt_package_install_list+=($pkg)
        fi
    done
    if [ ${#apt_package_install_list[@]} = 0 ];
	then
        return 0
    else
        eval $2=$apt_package_install_list
    fi
}


