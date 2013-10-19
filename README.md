# WSU Magento Development platform 
## Overview
The goal of this project is to make a very simple way for someone to do development against the 
production version of the Magento solution.  This setup is done in a way that should let the user follow 
only a few steps before then can login to the admin area and begin development work. 

1. install the base apps
    
    > 1. GITHUB ([win](http://windows.github.com/)|[mac](http://mac.github.com/)) 
    > 1. [Vagrant](https://www.virtualbox.org/)
    > 1. [VirtualBox](https://www.virtualbox.org/)
    > 1. [Ruby](http://rubyinstaller.org/)(only needed if using windows)
    > Note: if your on a mac you must have ruby 1.9 or above.  Look to [this articel to update your ruby](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
1. run in powershell/command line 
        
        > git clone git://github.com/washingtonstateuniversity/WSUMAGE-vagrant.git vvvbox

1. move to the new directory 
        
        > cd vvvbox

1. run in powershell/command line/terminal 
        
        > rake start

Now if this is the first time you have ever run then the `rake start` task will install anything 
that is needed and check to make sure everything is ok.  It'll prompt you as it goes, but after a 
few minutes the first time around, you will have the admin area for Magento up and ready to log in.
It really is as simple as these 4 steps to get up and running.  On a fresh system, seeing the Magento
admin page took about 5mins.  After that, it takes as little as 60 seconds (depending on your system's resources)

If you have use Vagrant, then you'll know that most of the time you need to mess with config files,
install plugins, and have to do some of your own clean up if you want to start from scratch.  
What this project is designed to do it wrap Vagrant in a `rake` task for Ruby.  By doing this we can 
perform tests that the host system is ready to `vagrant up` and can ask questions verse requiring 
the developer to mess around with the configs.  This means you can bring up and down a box much faster.

###Rake Tasks
Although you could just use the Vagrant commands, the whole point of this project is that there 
are questions about the envoiroment you want to set up.  In order to take advantage of this, here are a list of the rake tasks:

Primary Tasks

1. `rake start` :: basicly `vagrant up` but with prompts (this runs a few other tasks to ensure that the system is ready to `vagrant up`)
1. `rake end` :: this task is `vagrant destroy` with options to clean up the database if it needs it.
1. `rake hardclean` :: runs all the cleaners
1. `rake fresh` :: takes the system back to basic (will prompt to uninstall gems and vagrant plugins)
1. `rake restart` :: this task will time the runing of `rake end` and then `rake up` which should provide a very fast full down and up

Tasks to match Vagrant

1. `rake up` :: vagrant up ***(only adds timer and events)***
1. `rake destory` :: vagrant destory ***(only adds timer and events)***
1. `rake halt` :: vagrant halt ***(only adds timer and events)***
1. `rake reload` :: vagrant reload ***(only adds timer and events)***
1. `rake suspend` :: vagrant suspend ***(only adds timer and events)***
1. `rake pull` :: match the local to the production
1. `rake push` :: push up to production ***(would need to authenticate)***

Utility tasks

1. `rake clean_db` ::  This is to clear the shared database folder
1. `rake clean_www` :: This is to clear the shared web folder
1. `rake create_install_settings` :: create the settings for the installer
1. `rake test` :: this is for testing that all the plugins are there, if not then install them?
1. `rake open` :: Opens up your default browser and loads your url from settings



### Events
Because this is a ruby rake task wraper for Vagrant, we can add a few helpers to improve the process.
One of the first things is that there are event hooks that you can inject your personal parts to.  
All event files are located in `/rake/events` and will have the file name in the format  of `{Event_type}_{Task_name}.rb`.
The events that are set up for you are
    
1. Pre
1. Post
    
So for example if you wanting to do something before everything else when `rake start` is ran, then you would need 
to add your event file named, `Pre_start.rb`  There is a smaple file to look at as well in the `/rake` folder (`EXAMPLE_Pre_start.rb`).
From there you area now able to do more custom actions like copying some files in place or something.



##Custom parts
### Credentials and Such
All database usernames and passwords for Magento installations included by default are 
`devsqluser` and `devsqluser`.  You may also use the prompts to as everything is setting up 
to change this but changing the setting file.

All Magento admin usernames and passwords for the installations included by default 
are `admin` and `admin2013`.  Magento requires a number in the admin password, so remember 
if you change this in the settings file.

## Overall Sturcture
***note this need to be writen, short if 3 servers, admin/frontend/database***
###Option One development lite:
This option is designed for a lighter environment to aid in quick development.  Some
of the core parts of the production servers are rolled up into a single  server.  The upside
to this is that if you have a system that is not so robust then you shouldn't see lags.  Also
For most module development you are not depending on any other module, so matching production
in it's structure is not needed.  9 out of 10 projects will be fine starting with this.

###Option Two production match:
This is to match the production environment as closely as possible, and lot all modules as well.
Given that by default the xDebug is turned on, this can run slower.  When a module is vetted but 
a peer review, this environment will be used.  As of yet there is no unit tests, but when there are
they will be loaded in this development area.


#### Magento Stable
* URL: `http://local.mage.dev`
* DB Name: `mage`

#### MySQL Root
* User: `root`
* Pass: `blank`


### What's loaded on the systems?
There are 3 servers that run when mirroring the production servers, or just one if you want a deveploment base.

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
1. [adminer](http://www.adminer.org/) ** will not be found on production ever! **
1. [Magento 1.8.0](http://www.magentocommerce.com/download)
    Plugings Loaded:
    
    1. [WSUMAGE-admin-base](https://github.com/washingtonstateuniversity/WSUMAGE-admin-base.git)
    1. [WSUMAGE-theme-base](https://github.com/washingtonstateuniversity/WSUMAGE-theme-base.git)
    1. [eventTickets](https://github.com/jeremyBass/eventTickets.git)
    1. [Storeutilities](https://github.com/jeremyBass/Storeutilities.git)
    1. [WSUMAGE-structured-data](https://github.com/washingtonstateuniversity/WSUMAGE-structured-data.git)
    1. [Storeuser](https://github.com/jeremyBass/Storeuser.git)
    1. [sitemaps](https://github.com/jeremyBass/sitemaps.git)
    1. [webmastertools](https://github.com/jeremyBass/webmastertools.git)
    1. [ldap](https://github.com/jeremyBass/ldap.git)
    1. [pickupShipping](https://github.com/jeremyBass/pickupShipping.git)
    1. [AdminQuicklancher](https://github.com/jeremyBass/AdminQuicklancher.git)
    1. [dropshippers](https://github.com/jeremyBass/dropshippers.git)
    1. [Aoe_FilePicker](https://github.com/jeremyBass/Aoe_FilePicker.git)
    1. [mailing_services](https://github.com/jeremyBass/mailing_services.git)
    1. [WSUMAGE-iri-gateway](https://github.com/washingtonstateuniversity/WSUMAGE-iri-gateway.git)
    1. [custom_pdf_invoice](https://github.com/jeremyBass/custom_pdf_invoice.git)
    1. [Aoe_Profiler](https://github.com/fbrnc/Aoe_Profiler.git)
    1. [Aoe_ManageStores](https://github.com/fbrnc/Aoe_ManageStores.git)
    1. [Aoe_LayoutConditions](#https://github.com/fbrnc/Aoe_LayoutConditions.git)
    1. [Aoe_AsyncCache](https://github.com/fbrnc/Aoe_AsyncCache.git)
    1. [Aoe_ApiLog](https://github.com/fbrnc/Aoe_ApiLog.git)
    1. [Aoe_ClassPathCache](https://github.com/AOEmedia/Aoe_ClassPathCache.git)
    1. [Enhanced Admin Grids](https://github.com/mage-eag/mage-enhanced-admin-grids.git)

### Feedback?
keep it to your self.. no tell it like it is but atm there is no area to yell at except on here.

### Rightfully questioning this project extensiveness 
So moving forward, the ruby wrapper is built out to be able to have use for Wordpress (or any other setup) 
like many of the other vagrant projects, but should it be totally abstracted enough for that?  Maybe 
if there is interest it would be and at which point then there would be a wrapper project on its own 
and this would be reduced do to only the Magento parts of the environment.
