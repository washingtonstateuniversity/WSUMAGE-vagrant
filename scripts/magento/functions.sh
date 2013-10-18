#!/bin/bash
install_repo(){
    if [ $2 ]
    then
        git clone $1 -q
    else
        git clone $1 $2 -q
    fi
    success=$?
    if [[ $success -eq 0 ]];
    then
        cd $r/
        rm -rf LICENSE.txt STATUS.txt README.md RELEASE_NOTES.txt modman
        cd ../
        cp -af $r/* .
        rm -rf $r/

        rm -rf var/cache/*
        echo "cloned and installing $r"
        php "/srv/www/magento/index.php"
        #eval $3

        #if [ -z "$3" ]
        #then
        #    echo "no callback"
        #else
        #    eval $3
        #fi
    else
        echo "Something went wrong!"
    fi
    #sleep 1 # slow it down to insure that we have the items put in place.
}

#declare -A list = ( [repo]=gitUser )
install_repolist(){
    gitRepos=$1
    for r in "${!gitRepos[@]}" #loop with key as the var
    do
        giturl="git://github.com/${gitRepos[$r]}/$r.git"
        echo "Adding $r From $giturl"
        if [ -z "$r" ];
        then
            echo ""
        else
            #dbl check that the item is not null or 0
            if [ $r ]
            then
                install_repo $giturl $2 $3
            fi
        fi
        echo
    done
    return 1
}





install_tarrepo(){
    repozip=/srv/www/_depo/$2.zip
    if [ ! -f $repozip ]
    then
        wget -O $repozip $1
        echo "cloned and installing $2"
    else
        echo "$2 existed and installing "
    fi

    unzip $repozip -d /srv/www/magento/
    cd /srv/www/magento/
    cp -af "/srv/www/magento/$2-master/*" .
    rm -rf "/srv/www/magento/$2-master/"
    rm -rf LICENSE.txt STATUS.txt README.md RELEASE_NOTES.txt modman
    rm -rf var/cache/*
    php "/srv/www/magento/index.php"
    #sleep 1 # slow it down to insure that we have the items put in place.
}
#declare -A list = ( [repo]=gitUser )
install_tarrepo_list(){
    gitRepos=$1
    for r in "${!gitRepos[@]}" #loop with key as the var
    do
        giturl="https://github.com/${gitRepos[$r]}/$r/archive/master.zip"
        echo "Adding $r From $giturl"
        install_tarrepo $giturl $r
        echo
    done
    return 1
}
