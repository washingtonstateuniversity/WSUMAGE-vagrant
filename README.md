#notice:
Work on this repo most likely will not procced forward as we at WSU have decided that there should be a split between the server adn the app layer.  The combination is https://github.com/washingtonstateuniversity/WSU-Web-Serverbase as the server base, which you can load the application layer of your wish.  In order to gain the same set up with Magento watch https://github.com/washingtonstateuniversity/WSUMAGE-base as that will be where this repo is being ported over to.  The timeline for this port will be quick.  We will leave this repo open as a learning aid as long as WSU can permit.  




###NOTE MASTER IS BETA
***NOTICE: it seems that not every version of [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) play nicely together or with the OS.  If you can't get them running try to down grade your VirtualBox first.  A list of known working combinations will be added to the wiki***



# WSU Magento Development platform 
### Overview
The goal of this project is to make a very simple way for someone to do development against the 
production version of the Magento solution.  This setup is done in a way that should let the user follow 
only a few steps before then can login to the admin area and begin development work. 

### Why a Ruby task warper?
There is no way to prompt the user and we need to be able to ask questions like `would you like to clean the database? [y/n]`.  This wrapper lets us achieve this need.

##Install

1. install the base apps
    
    > 1. GITHUB ([win](http://windows.github.com/)|[mac](http://mac.github.com/)) 
    > 1. [Vagrant](http://www.vagrantup.com/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    > 1. [VirtualBox](https://www.virtualbox.org/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    > 1. [Ruby](http://rubyinstaller.org/)(only needed if using windows see the [wiki for help](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-ruby))
    > ***Note: if your on a mac you must have ruby 1.9 or above.  Look to [this article to update your ruby](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)***
1. run in powershell/command line 
        
        > git clone git://github.com/washingtonstateuniversity/WSUMAGE-vagrant.git magedev

1. move to the new directory 
        
        > cd magedev

1. run in powershell/command line/terminal 
        
        > rake start

Some this to note is that you wil be asked questions.  If you need help, look to the [task options wiki page](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Taks-Options)

Now if this is the first time you have ever run then the `rake start` task will install anything 
that is needed and check to make sure everything is ok.  It'll prompt you as it goes, but after a 
few minutes the first time around, you will have the admin area for Magento up and ready to log in.
It really is as simple as these 4 steps to get up and running.  On a fresh system, seeing the Magento
admin page took about 5-10 minutes depending on the power of the machine your ran it on and it's internet
connections.  There will be a tune it up section in the wiki area later on.

If you have use Vagrant, then you'll know that most of the time you need to mess with config files,
install plugins, and have to do some of your own clean up if you want to start from scratch.  
What this project is designed to do it wrap Vagrant in a `rake` task for Ruby.  By doing this we can 
perform tests that the host system is ready to `vagrant up` and can ask questions verse requiring 
the developer to mess around with the configs.  This means you can totally bring up and down a box much 
faster by automating as much as possible.

***
##The Ruby wrapper
###Rake Tasks
Although you could just use the Vagrant commands, the whole point of this project is that there 
are questions about the environment you want to set up.  In order to take advantage of this, here are a list of the rake tasks:

**Primary Tasks**

1. `rake start` :: basically `vagrant up` but with prompts (this runs a few other tasks to ensure that the system is ready to `vagrant up`)
1. `rake end` :: this task is `vagrant destroy` with options to clean up the database if it needs it.
1. `rake hardclean` :: runs all the cleaners
1. `rake fresh` :: takes the system back to basic (will prompt to uninstall gems and vagrant plugins)
1. `rake restart` :: this task will time the running of `rake end` and then `rake up` which should provide a very fast full down and up

**Tasks to match Vagrant**

1. `rake up` :: vagrant up ***(only adds timer and events)***
1. `rake destroy` :: vagrant destroy ***(only adds timer and events)***
1. `rake halt` :: vagrant halt ***(only adds timer and events)***
1. `rake reload` :: vagrant reload ***(only adds timer and events)***
1. `rake suspend` :: vagrant suspend ***(only adds timer and events)***
1. `rake pull` :: match the local to the production
1. `rake push` :: push up to production ***(would need to authenticate)***

**Utility tasks**

1. `rake clean_db` ::  This is to clear the shared database folder
1. `rake clean_www` :: This is to clear the shared web folder
1. `rake create_install_settings` :: create the settings for the installer
1. `rake test` :: this is for testing that all the plugins are there, if not then install them?
1. `rake open` :: Opens up your default browser and loads your url from settings



### Events
Because this is a ruby rake task wrapper for Vagrant, we can add a few helpers to improve the process.
One of the first things is that there are event hooks that you can inject your personal parts to.  
All event files are located in `/rake/events` and will have the file name in the format  of `{Event_type}_{Task_name}.rb`.
The events that are set up for you are
    
1. Pre
1. Post
    
So for example if you wanting to do something before everything else when `rake start` is ran, then you would need 
to add your event file named, `/Pre_start.rb`  There is a sample file to look at as well in the `/rake` folder (`EXAMPLE_Pre_start.rb`).
From there you area now able to do more custom actions like copying some files in place or something.

###Gems that are autoloaded
1. [json](http://rubygems.org/gems/json)
1. [highline](http://rubygems.org/gems/highline)
1. [launchy](http://rubygems.org/gems/launchy)

***
##Vagrant
Just to note you can by pass the rake taskes and just use Vagrant on it's own, but you will have to magage your files on your own, and make sure that you edit your configs too.  There is a lot to learn under the hood.

###Vagrant plugins that are autoloaded
1. [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) - This is to auto append any domains you create to your host file so you don't have to do it by hand.
1. [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) - This is to help in cases where the VirtualBox and Vagrant are not in line and the GuestAdditions versions on your host and guest do not match.  ***This just patches it, and it is highly advisable to update (Vagrant/VirtualBox) as soon as possible since this plugin adds a minute or two to the process of bring up the box.***

***
## Customizable settings
### Overall Structure

1. **Option One development lite:**
    This option is designed for a lighter environment to aid in quick development.  Some
    of the core parts of the production servers are rolled up into a single  server.  The upside
    to this is that if you have a system that is not so robust then you shouldn't see lags.  Also
    For most module development you are not depending on any other module, so matching production
    in it's structure is not needed.  9 out of 10 projects will be fine starting with this.

1. **Option Two production match:**
    This is to match the production environment as closely as possible, and lot all modules as well.
    Given that by default the xDebug is turned on, this can run slower.  When a module is vetted but 
    a peer review, this environment will be used.  As of yet there is no unit tests, but when there are
    they will be loaded in this development area. ***note this need to be written out more, short if 3 servers, admin/frontend/database***

### Credentials and Such


#### MySQL Root ***(defaults)***
* User: `root`
* Pass: `blank`

All database usernames and passwords for Magento installations included by default are 
`devsqluser` and `devsqluser`.  You may also use the prompts to as everything is setting up 
to change this but changing the setting file.

All Magento admin usernames and passwords for the installations included by default 
are `admin` and `admin2013`.  Magento requires a number in the admin password, so remember 
if you change this in the settings file.

#### Magento Stable ***(defaults)***
* DB Name: `mage`
* DB user: `devsqluser`
* DB pass: `devsqluser`

#####URLS
* `http://store.mage.dev`
* `http://events.store.mage.dev`
* `http://general.store.mage.dev`
* `http://student.store.mage.dev`
* `http://tech.store.mage.dev`

**Note: this is auto appended and removed from your system's `HOST` file**


### What's loaded on the systems?
There are 3 master servers that run when mirroring the production servers, or just one if you want a development base.
**note:** This set up is currently a Shell provisioner only.  Later when branching, there will be a 
switch to CentOS and to a new provisioner option.  Currently options are Chef and Salt as considered

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
1. [adminer](http://www.adminer.org/) **will not be found on production ever!**
1. [Magento 1.8.0](http://www.magentocommerce.com/download)
**Note this is the highlights, for a full list look [here](#)**

*** 
#Magento Setup
Plugings Loaded:
    
1. [WSUMAGE-admin-base](https://github.com/washingtonstateuniversity/WSUMAGE-admin-base.git)
1. [WSUMAGE-theme-base](https://github.com/washingtonstateuniversity/WSUMAGE-theme-base.git)
1. [WSUMAGE-auditing](https://github.com/washingtonstateuniversity/WSUMAGE-auditing.git)
1. [WSUMAGE-store-utilities](https://github.com/washingtonstateuniversity/WSUMAGE-store-utilities .git)
1. [WSUMAGE-structured-data](https://github.com/washingtonstateuniversity/WSUMAGE-structured-data.git)
1. [WSUMAGE-iri-gateway](https://github.com/washingtonstateuniversity/WSUMAGE-iri-gateway.git)
1. [WSUMAGE-networksecurities ](https://github.com/washingtonstateuniversity/WSUMAGE-networksecurities.git)
1. [WSUMAGE-central-cc-processing](https://github.com/washingtonstateuniversity/WSUMAGE-central-cc-processing.git)
1. [Storeuser](https://github.com/jeremyBass/Storeuser.git)
1. [sitemaps](https://github.com/jeremyBass/sitemaps.git)
1. [eventTickets](https://github.com/jeremyBass/eventTickets.git)
1. [webmastertools](https://github.com/jeremyBass/webmastertools.git)
1. [pickupShipping](https://github.com/jeremyBass/pickupShipping.git)
1. [AdminQuicklancher](https://github.com/jeremyBass/AdminQuicklancher.git)
1. [dropshippers](https://github.com/jeremyBass/dropshippers.git)
1. [Aoe_FilePicker](https://github.com/jeremyBass/Aoe_FilePicker.git)
1. [mailing_services](https://github.com/jeremyBass/mailing_services.git)
1. [Aoe_Profiler](https://github.com/jeremyBass/Aoe_Profiler.git)
1. [Aoe_ManageStores](https://github.com/fbrnc/Aoe_ManageStores.git)
1. [Aoe_AsyncCache](https://github.com/fbrnc/Aoe_AsyncCache.git)
1. [Aoe_ApiLog](https://github.com/fbrnc/Aoe_ApiLog.git)
1. [Aoe_ClassPathCache](https://github.com/AOEmedia/Aoe_ClassPathCache.git)
1. [Enhanced Admin Grids](https://github.com/mage-eag/mage-enhanced-admin-grids.git)

####Magento Settings
For the development environment is a set base setting that you will receive when you first get your store 
set up on the production area.  When you use the match, an authentication process will be done the first time
then you will be able to make calls to production thru the API.   This will allow you to sink up you store 
to your development area to test out a bug you are seeing or design something that is very specific to the 
settings and content that is on the server.

## Sample Data
There is an updated version of the old Magento sample data that is loaded.  Currently part of it is housed under this project but will be moved over.  The [WSUMAGE-sampledata](https://github.com/washingtonstateuniversity/WSUMAGE-sampledata) project right now is a set of simple SQL script, but in the interest of easy it will be turned into an extension.



*** 
#`rake start` times
This will give you an accurate time of loading the server.  Thie first run as it primes the system, installs any missing items and getting Magento installed for the first time can take a bit, 10-20 mins depending on bandwidth, but the next time you bring up the box times can run as low as 3-4mins for a fresh `rake start`/`vagrant up`.  There are ways to help insure that Vagrant runs as fast as possible, so here are a few we can share:

1. Run everything of an SSD (solid state drive) for the fastest IO since sharing folders from your system can be slow
1. Install NSF if possible
1. Don't clean the install everytime, just clean the database
1. package the first run and the next time you `rake start`/`vagrant up` will use that new box state which will quicken the loading.


***

### Rightfully questioning this project extensiveness 
So moving forward, the ruby wrapper is built out to be able to have use for Wordpress (or any other setup) 
like many of the other vagrant projects, but should it be totally abstracted enough for that?  Maybe 
if there is interest it would be and at which point then there would be a wrapper project on its own 
and this would be reduced do to only the Magento parts of the environment.

### Feedback?
keep it to your self.. no tell it like it is but atm there is no area to yell at except on here.

## Contributing

If you find what looks like a bug:

1. Search the [mailing list] COMING SOON
2. Check the [GitHub issue tracker](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/issues) to see if anyone else has reported issue.
3. If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix: (will be better defined later)

1. Fork the project on GitHub.
2. Make your changes with tests.
3. Commit the changes to your fork.
4. Send a pull request.

***
Original Author: jeremyBass 
