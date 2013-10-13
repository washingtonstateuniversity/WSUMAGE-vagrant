#the goal of this file is that you 
#build your total production server
#with options

##note not happy with the start init loop, work on that

load 'rake/helper.rb'
require 'highline/import'
require 'fileutils'

mi =MAGEINSTALLER.new

=begin
    Maybe what is needed is a first run type thing.  Test for everything
    task list
        :test #this is for testing that all the plugins are there, if not then install them?
        :open (more for testing) Opens up your default browser and loads your url from settings

        :init setup the system
        :start #vagrant up but with prompts
        :end #destroy with options to clean up

        :up #vagrant up (only adds timer and events)
        :destory #vagrant destory (only adds timer and events)
        :halt #vagrant halt (only adds timer and events)
        :reload #vagrant reload (only adds timer and events)
        :resume #vagrant resume (only adds timer and events)
        :suspend #vagrant suspend (only adds timer and events)

        :pull #match the local to the production
        :push #push up to production (would need to authenticate)

        :hardclean 
        :clean_db
        :clean_www
        :create_install_settings #create the settings for the installer
=end





desc "prepare  the system"
task :init do
    stopwatch = Stopwatch.new
    mi.get_pre_task()

    Rake::Task["test"].reenable
    Rake::Task["test"].invoke
    
    mi.get_post_task()
    stopwatch.end

    puts "> We have settup everything, only last"
    puts "> thing to do when ready is `rake start`"
    if !fresh
        uinput = agree("Would you like to start? <%= color('[y/n]', :bold) %>")
        if uinput
            Rake::Task["start"].reenable
            Rake::Task["start"].invoke
        end
    end
end

desc "test  the system"
task :test do
    say("testing the system now")
    fresh=false
    puts "insuring default folders"
    mi.create_dir("/www/")
    mi.create_dir("/_BOXES/")
    mi.create_dir("/database/data/")
    #this is where we would build the Vagrant file to suite if abstracted to account for 
    #more then this project    
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
        puts "vagrant-hostsupdater plugin loaded"
    end
    
    output = `gem list`
    if !output.include? "highline"
        puts "installing highline gem"
        output = `gem install highline`
        puts output
        fresh=true
    else
        puts "highline gem loaded"
    end
    output = `gem list`
    if !output.include? "launchy"
        puts "installing launchy gem"
        output = `gem install launchy`
        puts output
        fresh=true
    else
        puts "launchy gem loaded"
    end
    
end


desc "Set up the VM with questions"
task :start do
    stopwatch = Stopwatch.new
    Rake::Task["test"].reenable
    Rake::Task["test"].invoke
    mi.get_pre_task()
    uinput = agree("Use last run? <%= color('[y/n]', :bold) %>")
    if uinput
         system( "vagrant up" )
    else
        mode = ask("Use development <%= color('lite', :bold) %> OR production <%= color('match', :bold) %>?  <%= color('[l/m]', :bold) %>  ") do |q|
          q.validate                 = /\Al(?:ite)?|m(?:atch)?\Z/i
          q.responses[:not_valid]    = 'Please enter "l" or "m" (lite|match).'
          q.responses[:ask_on_error] = :question
        end
#todo still basicly add a global lite or match?
        if mode=="l"
            puts "working on the lite mode"
        else
            puts "working on the match mode"
        end
#www root folder
        if Dir['www/*'].empty?
            uinput = agree("Should WWW folder be cleared? <%= color('[y/n]', :bold) %>")
            if uinput
                Rake::Task["clean_www"].reenable
                Rake::Task["clean_www"].invoke
            end
        end
#database
        if Dir['database/data/*'].empty?
            uinput = agree("Should all the databases be cleared? <%= color('[y/n]', :bold) %>")
            if uinput
                Rake::Task["clean_db"].reenable
                Rake::Task["clean_db"].invoke
            end
        end
#installer settings
        target  = "scripts/install_settings.sh"
        file = File.join(Dir.pwd, target)
        if File.exist?(file)
            uinput = agree("Should we clear the past install settings file?  <%= color('[y/n]', :bold) %>")
            if uinput

                FileUtils.rm_rf(file)
                say("<%= color('removed file #{file}', :bold, :red, :on_black) %>")
                Rake::Task["create_install_settings"].reenable
                Rake::Task["create_install_settings"].invoke
              else
                puts "using the past installer settings"
            end
        else
            Rake::Task["create_install_settings"].reenable
            Rake::Task["create_install_settings"].invoke
        end
        
        
        puts "Finished lets go [any key to continue]"
        input = STDIN.gets.strip
        # code to time
        system( "vagrant up" )
    end

    mi.get_post_task()
    stopwatch.end

    Rake::Task["open"].reenable
    Rake::Task["open"].invoke  
end

desc "Destroy the vagrant with call back functions run"
task :end do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    system( "vagrant destroy -f" )
    uinput = agree("Should all the databases be cleared?   <%= color('[y/n]', :bold) %>")
    if uinput
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
    end
    
    mi.get_post_task()
    stopwatch.end
end






desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :up do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    system( "vagrant up" )
    mi.get_post_task()
    stopwatch.end
    Rake::Task["open"].reenable
    Rake::Task["open"].invoke
end

desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :destroy do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    system( "vagrant destroy" )
    mi.get_post_task()
    stopwatch.end
end

desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :halt do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    system( "vagrant halt" )
    mi.get_post_task()
    stopwatch.end
end



#note just for testing/ like a bonus
task :open do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    require 'launchy'
    Launchy.open("http://local.mage.dev/admin") #note this should be from setting file
    
    mi.get_post_task()
    stopwatch.end
end




#these should maybe be extracted out?
task :hardclean do
    stopwatch = Stopwatch.new
    mi.get_pre_task()
    output=`vagrant destroy -f`
    puts output
    Rake::Task["clean_www"].reenable
    Rake::Task["clean_www"].invoke   

    Rake::Task["clean_db"].reenable
    Rake::Task["clean_db"].invoke
    
    mi.get_post_task()
    stopwatch.end
end

desc "clean the database"
task :clean_db do
  puts "cleaning the database"
  FileUtils.rm_rf(Dir.glob('database/data/*'))
  puts "database is clean"
end

#maybe abstract this of other apps
desc "clean the database"
task :clean_www do
  puts "cleaning the WWW folder"
  FileUtils.rm_rf(Dir.glob('www/*'))
  puts "The WWW has been cleaned"
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
    require 'digest/md5'

    file="scripts/install_settings.sh"
    mi.file_remove(file); #clear fisrt
    mi.add_setting(file,"#!/bin/bash\n")
    mi.add_setting(file,"bs_MAGEversion=\"1.8.0.0\"\n")
    mi.add_setting(file,"bs_url=\"local.mage.dev\"\n")

#host
    uinput = agree("database HOST, use the default <%= color('`localhost`', :bold) %>? [y/n]")
    if uinput
        #maybe check vagrant? if not lets go the hard coded, but for now we'll localhost
        mi.add_setting(file,"bs_dbhost=\"localhost\"\n")
    else
        input = ask("database host:")
        mi.add_setting(file,"bs_dbhost=\"#{input}\"\n")
    end
#dbname
    uinput = agree("database NAME, use the default <%= color('`mage`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"bs_dbname=\"mage\"\n")
    else
        mi.add_setting(file,"bs_dbname=\"#{uinput}\"\n")
    end
#dbuser
    uinput = agree("database USER, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"bs_dbuser=\"devsqluser\"\n")
    else
        input = ask("database user:")
        mi.add_setting(file,"bs_dbuser=\"#{input}\"\n")
    end
#dbpass
    uinput = agree("database USER PASS, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"bs_dbpass=\"devsqluser\"\n")
    else
        input = ask("database password:")
        mi.add_setting(file,"bs_dbuser=\"#{input}\"\n")
    end
#install sample data
    puts "SAMPLE DATA *** would you like to install this?[y/n]"
    uinput = agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"bs_install_sample=\"true\"\n")
    else
        mi.add_setting(file,"bs_install_sample=\"false\"\n")
    end

#use ldap
    uinput = agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: must be within network', :bold, :yellow, :on_black) %>")
    if uinput
        mi.add_setting(file,"bs_use_ldap\"true\"\n")
    else
        mi.add_setting(file,"bs_use_ldap=\"false\"\n")
    end
######
    
#add your nid for LDAP based tests
    uinput = agree("Add your own personal user?[y/n]  <%= color('*** the default user is still installed ***', :bold, :yellow, :on_black) %>")
    if uinput

        uinput = ask("<%= color('*** This must be your NID if using LDAP ***', :bold, :yellow, :on_black) %>\nUsername:") do |q| 
                    q.validate = /.+/ 
                    q.responses[:not_valid]    = 'Must not be blank'
                    q.responses[:ask_on_error] = :question
                end
        if uinput != ''
            mi.add_setting(file,"bs_custom_adminuser=\"#{uinput}\"\n")
        end

#user pass
        say("<%= color('*** must be alphanumeric and min 8 length \n*** When using LDAP it is your AD password', :bold, :yellow, :on_black) %>\n")
        pass = ask("<%= @key %>:  ") do |q|
            q.echo = '*'
            q.verify_match = true
            q.validate  = /^(?=.*[0-9])(?=.*[A-Za-z]).{8,}$/
            q.responses[:not_valid]    = "<%= color('password must be min 8 characters with numbers', :bold, :red, :on_black) %>"
            q.gather = {"Enter a password" => '',
                        "Verify password" => ''}
        end
        #not working, recheck this
        if(!(pass =~ /^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$  /))
            puts "That password very weak? try again? [y/n]"
            input = STDIN.gets.strip
            if input == 'y'
                puts "NOTE:"
                puts "*** must be alphanumeric *** When using LDAP it's your AD password ***"
                puts "Try two uppercase letters/one special case letter (!@#$&*)/two digits/three lowercase"
                puts "letters with a min length of 8 charcters"
                pass = ask("<%= @key %>:  ") do |q|
                    q.echo = '*'
                    q.verify_match = true
                    q.validate  = /^(?=[A-Za-z0-9]).{8,}$/
                  q.gather = {"Enter a password: *** must be alphanumeric *** When using LDAP it's your AD password ***" => '',
                              "Please type it again for verification" => ''}
                end
            end    
        end
        pass=Digest::MD5.hexdigest(pass) #don't want usernames hanging around
        mi.add_setting(file,"bs_custom_adminpass=\"#{pass}\"\n")

#first name
        uinput = ask("First name:") do |q| 
            q.validate = /.+/ 
            q.responses[:not_valid]    = 'Must not be blank'
            q.responses[:ask_on_error] = :question
        end
        mi.add_setting(file,"bs_custom_adminfname=\"#{uinput}\"\n")
        
#last name
        uinput = ask("Last name:")  do |q| 
            q.validate = /.+/ 
            q.responses[:not_valid]    = 'Must not be blank'
            q.responses[:ask_on_error] = :question
        end
        mi.add_setting(file,"bs_custom_adminlname=\"#{uinput}\"\n")
 
#email
        uinput = ask("Email:") { |q| 
            q.validate  = mi.test_email
            q.responses[:not_valid]    = "<%= color('you must use a valid email.', :bold, :red, :on_black) %>"
        }
        mi.add_setting(file,"bs_custom_adminlemail=\"#{uinput}\"\n")
 
    end
    
    #default user must be there
    mi.add_setting(file,"bs_adminuser=\"admin\"\n")
    mi.add_setting(file,"bs_adminpass=\"admin2013\"\n")
    mi.add_setting(file,"bs_adminfname=\"MC\"\n")
    mi.add_setting(file,"bs_adminlname=\"Lovin\"\n")
    mi.add_setting(file,"bs_adminemail=\"test.user@wsu.edu\"\n")

    puts "the installer setting have been created"
end



