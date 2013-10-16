# -*- mode: ruby -*-
# vi: set ft=ruby :
dir = Dir.pwd
Vagrant.configure("2") do |config|

    config.vm.provision "shell", inline: "echo Hello"
  
    config.vm.define "web", primary: true do |web_config|
        web_config.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        web_config.ssh.forward_agent = true
        web_config.vm.hostname  = "web"
        
        if defined? VagrantPlugins::HostsUpdater
            config.hostsupdater.aliases = [
              "web",
              "local.mage.dev"
            ]
        end
            
        
        web_config.vm.box = "precise32"
        web_config.vm.box_url = "_BOXES/precise32.box"   ##"http://files.vagrantup.com/precise32.box"
        web_config.vm.network :private_network, ip: "192.168.50.4"
        #web_config.vm.forward_port 22, 2210
        
        #remove
        web_config.vm.synced_folder "database/", "/srv/database"
        web_config.vm.synced_folder "database/data/", "/var/lib/mysql", :mount_options => [ "dmode=777", "fmode=777" ]
        #end
        
        web_config.vm.synced_folder "config/", "/srv/config"
        web_config.vm.synced_folder "config/nginx-config/sites/", "/etc/nginx/custom-sites"
        web_config.vm.synced_folder "depo/", "/srv/www/depo", :owner => "www-data", :mount_options => ['dmode=775,fmode=774']
        web_config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => ['dmode=775,fmode=774']
        web_config.vm.synced_folder "scripts/", "/srv/www/scripts/", :owner => "www-data", :mount_options => ['dmode=775,fmode=774']
        web_config.vm.provision :shell, :path => File.join( "provision", "provision.sh" )
    end
end
