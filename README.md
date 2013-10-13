# WSU Magento Vagrant 
## Overview
The goal of this project is to make a very simple way for someone to do development against the production version of the Magento solution.  It's done in a way that should let the user follow only a few steps before then can login to the admin area and begin development work. 

1. install GITHUB ([win](http://windows.github.com/)|[mac](http://mac.github.com/)) / [Vagrant](https://www.virtualbox.org/) / [VirtualBox](https://www.virtualbox.org/) / [Ruby](http://rubyinstaller.org/)(win)
1. run in powershell/command line `git clone git://github.com/washingtonstateuniversity/WSUMAGE-vagrant.git vvvbox`
1. move to the new directory `cd vvvbox`
1. run in powershell/command line `rake init`

Now if this is the first time you well have some things it'll check to make sure everything is ok.  I'll prompt you as it goes, but after a few minutes the first time around, you will have the admin area for Magento up and ready to log in.

If you have use Vagrant, then you'll know that most of the time you need to mess with config files, install plugins, and have to do some of your own clean up if you want to start from scratch.  What this project is designed to do it wrap Vagrant in a `rake` task for Ruby.  By doing this we can perform tests that the host system is ready to `vagrant up` and can ask questions verse requiring the developer to mess around with the configs.  This means you can bring up and down a box much faster.

### Credentials and Such

All database usernames and passwords for Magento installations included by default are `devsqluser` and `devsqluser`.  You may also use the prompts to as everything is setting up to change this but changing the setting file.

All Magento admin usernames and passwords for the installations included by default are `admin` and `admin2013`.  Magento requires a number in the admin password, so remember if you change this in the settings file.

## Overall Sturcture
***note this need to be writen, short if 3 servers, admin/frontend/database***

#### Magento Stable
* URL: `http://local.mage.dev`
* DB Name: `mage`

#### MySQL Root
* User: `root`
* Pass: `blank`


### What do you get?
A bunch of stuff!

1. [Ubuntu](http://ubuntu.com) 12.04 LTS (Precise Pangolin)
1. [nginx](http://nginx.org) 1.4.2
1. [mysql](http://mysql.com) 5.5.32
1. [php-fpm](http://php-fpm.org) 5.4.17
1. [memcached](http://memcached.org/) 1.4.13
1. PHP [memcache extension](http://pecl.php.net/package/memcache/3.0.8) 3.0.8
1. [xdebug](http://xdebug.org/) 2.2.3
1. [PHPUnit](http://pear.phpunit.de/) 3.7.24
1. [ack-grep](http://beyondgrep.com/) 2.04
1. [git](http://git-scm.com) 1.8.3.4
1. [ngrep](http://ngrep.sourceforge.net/usage.html)
1. [dos2unix](http://dos2unix.sourceforge.net/)
1. [phpMemcachedAdmin](https://code.google.com/p/phpmemcacheadmin/) 1.2.2 BETA
1. [adminer](http://www.adminer.org/)

### Feedback?
keep it to your self.. no tell it like it is but atm there is no area to yell at us.