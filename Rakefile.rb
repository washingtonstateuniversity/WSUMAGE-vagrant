load 'rake/helper.rb'
=begin
    Maybe what is needed is a first run type thing.  Test for everything
    task list
        :test #this is for testing that all the plugins are there, if not then install them?
        :create_install_settings #create the settings for the installer
        :start #vagrant up but with prompts
        :end #destroy with options to clean up
        :pull #match the local to the production
        :push #push up to production (would need to authenticate)
        :clean_db
        :clean_mage_intsall
        :create_install_settings
=end

desc "prepare  the system"
task :init do
    mi =MAGEINSTALLER.new
    puts "cearting default folders"
    mi.create_dir("/www/")
    mi.create_dir("/_BOXES/")
    mi.create_dir("/database/data/")
    
    fresh=false
    
    file='_BOXES/precise32.box'
    if !File.exist?(file)
        mi.download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box',file)
    else
        puts "base box esited"
    end
    output = `vagrant plugin list`
    if !output.include? "vagrant-hostsupdater"
        puts "installing vagrant-hostsupdater plugin"
        output = `vagrant plugin install vagrant-hostsupdater`
        puts output
    else
        puts "skipping vagrant-hostsupdater plugin, installed already"
    end
    
    output = `gem list`
    if !output.include? "highline"
        puts "installing highline gem"
        output = `gem install highline`
        puts output
        fresh=true
    else
        puts "skipping highline gem, installed already"
    end
    output = `gem list`
    if !output.include? "launchy"
        puts "installing launchy gem"
        output = `gem install launchy`
        puts output
        fresh=true
    else
        puts "skipping launchy gem, installed already"
    end
    

        
    puts "> We have settup everything, only last"
    puts "> thing to do when ready is `rake start`"
    if !fresh
        puts "Would you like to start? [y/n]"
        input = STDIN.gets.strip
        if input == 'y'
            Rake::Task["start"].reenable
            Rake::Task["start"].invoke
        end
    end
end

desc "test  the system"
task :test do
    puts "the lotion on the skin"
end


desc "Set up the VM"
task :start do
    require 'fileutils'
    mi =MAGEINSTALLER.new
    
    puts "Should past MAGE installs be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_mage_intsall"].reenable
        Rake::Task["clean_mage_intsall"].invoke
    end

    #should be testing first
    puts "Should the databases be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
    end


    puts "Should we clear the past install settings? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        target  = "scripts/install_settings.sh"
        file = File.join(Dir.pwd, target)
        FileUtils.rm_rf(file)
        puts "removed file #{file}" 
          
        Rake::Task["create_install_settings"].reenable
        Rake::Task["create_install_settings"].invoke
          
          
      else
      puts "using the past installer settings"
    end

    puts "Finished lets go [any key to continue]"
    input = STDIN.gets.strip
    
    exec 'vagrant up'   ## for now just start here but look to 
                        ## http://tech.natemurray.com/2007/03/ruby-shell-commands.html or
                        ## or try to get to vagrant CLI
end

#note just for testing
task :open do
    require 'launchy'
    Launchy.open("http://local.mage.dev/admin")
end



task :hardclean do
    output=`vagrant destroy -f`
    puts output
    Rake::Task["clean_mage_intsall"].reenable
    Rake::Task["clean_mage_intsall"].invoke   

    Rake::Task["clean_db"].reenable
    Rake::Task["clean_db"].invoke
end


desc "Destroy the vagrant with call back functions run"
task :end do
    output=`vagrant destroy -f`
    puts "Should the databases be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
    end

end


desc "clean the database"
task :clean_db do
  puts "cleaning the database"
  FileUtils.rm_rf(Dir.glob('database/data/*'))
  puts "database is clean"
end

#maybe abstract this of other apps
desc "clean the database"
task :clean_mage_intsall do
  puts "cleaning the MAGE install"
  FileUtils.rm_rf(Dir.glob('www/mage/*'))
  puts "The Magento install has been removed"
end


desc "push to production"#note this would be from a setting file
task :deploy do
   puts "push to the server"
end

desc "pull from production"#note this would be from a setting file
task :pull do
   puts "grabbing files and things"
end

desc "Create a setting file"#maybe abstract this 
task :create_install_settings do
    require 'highline/import'
    require 'digest/md5'

    
    mi =MAGEINSTALLER.new

    #MAGEversion="1.8.0.0"
    #dbhost="localhost"
    #dbname="mage"
    #dbuser="devsqluser"
    #dbpass="devsqluser"
    #url="local.mage.dev"
    #adminuser="admin"
    #adminpass="admin2013"
    #adminfname="Mc"       
    #adminlname="Lovin"
    #adminemail="test.user@wsu.edu"
    mi.add_setting("#!/bin/bash\n")
    mi.add_setting("MAGEversion=\"1.8.0.0\"\n")
    mi.add_setting("url=\"local.mage.dev\"\n")


    
    puts "database host of mage? [default localhost]"
    input = STDIN.gets.strip
    if input == ''
        #maybe check vagrant?
        #if not lets go the hard coded, but for
        #now we'll localhost
        mi.add_setting("dbhost=\"localhost\"\n")
    else
        mi.add_setting("dbhost=\"#{input}\"\n")
    end

    puts "database name of mage? [default mage]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbname=\"mage\"\n")
    else
        mi.add_setting("dbname=\"#{input}\"\n")
    end

    puts "database user of mage? [default devsqluser]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbuser=\"devsqluser\"\n")
    else
        mi.add_setting("dbuser=\"#{input}\"\n")
    end

    puts "database user's password of mage? [default devsqluser]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbpass=\"devsqluser\"\n")
    else
        mi.add_setting("dbpass=\"#{input}\"\n")
    end

    puts "SAMPLE DATA *** would you like to install this?[y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        mi.add_setting("install_sample=\"true\"\n")
    else
        mi.add_setting("install_sample=\"false\"\n")
    end
    
    puts "Add your own personal user?[y/n]  *** the default user is still installed ***"
    input = STDIN.gets.strip
    if input == 'y'
        puts "Username: *** This must be your NID if using LDAP ***"
        uinput = STDIN.gets.strip
        if uinput != ''
            mi.add_setting("custom_adminuser=\"#{uinput}\"\n")
        end
        
        #so here is a good example of where we want to pull out so we can check and loop
        pass = ask("Enter your password: *** must be alphanumeric *** When using LDAP it's your AD password ***") { |q| q.echo = "x" }
        pass2 = ask("RE-Enter your password:") { |q| q.echo = "x" }
        if pass != '' && pass == pass
            pass=Digest::MD5.hexdigest(pass) #don't want usernames hanging around
            mi.add_setting("custom_adminpass=\"#{pass}\"\n")
        end  

        puts "First name:"
        uinput = STDIN.gets.strip
        if uinput != ''
            mi.add_setting("custom_adminfname=\"#{uinput}\"\n")
        end      
        puts "Last name:"
        uinput = STDIN.gets.strip
        if uinput != ''
            mi.add_setting("custom_adminlname=\"#{uinput}\"\n")
        end
    end
    
    
    mi.add_setting("adminuser=\"admin\"\n")
    mi.add_setting("adminpass=\"admin2013\"\n")
    mi.add_setting("adminfname=\"MC\"\n")
    mi.add_setting("adminlname=\"Lovin\"\n")
    mi.add_setting("adminemail=\"test.user@wsu.edu\"\n")
    
    

    puts "the installer setting have been created"
end



