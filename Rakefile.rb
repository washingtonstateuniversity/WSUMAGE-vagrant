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
    start = Time.now

    
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
    # code to time
    
        system( "vagrant up" )
    
    finish = Time.now
    diff = finish - start

    hours = diff / 3600.to_i
    mins = (diff / 60 - hours * 60).to_i
    secs = (diff - (mins * 60 + hours * 3600))
    printf("%02d:%02d:%02d\n", hours, mins, secs)

    puts "time taken  for set up:  #{hours}:#{mins}:#{secs} "

    Rake::Task["open"].reenable
    Rake::Task["open"].invoke
    
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
    system( "vagrant destroy -f" )
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

    file="scripts/install_settings.sh"
    mi.file_remove(file); #clear fisrt
    mi.add_setting(file,"#!/bin/bash\n")
    mi.add_setting(file,"MAGEversion=\"1.8.0.0\"\n")
    mi.add_setting(file,"url=\"local.mage.dev\"\n")

#host
    uinput = agree("database HOST, use the default <%= color('`localhost`', :bold) %>? [y/n]")
    if uinput
        #maybe check vagrant? if not lets go the hard coded, but for now we'll localhost
        mi.add_setting(file,"dbhost=\"localhost\"\n")
    else
        input = ask("database host:")
        mi.add_setting(file,"dbhost=\"#{input}\"\n")
    end
#dbname
    uinput = agree("database NAME, use the default <%= color('`mage`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"dbname=\"mage\"\n")
    else
        mi.add_setting(file,"dbname=\"#{uinput}\"\n")
    end
#dbuser
    uinput = agree("database USER, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"dbuser=\"devsqluser\"\n")
    else
        input = ask("database user:")
        mi.add_setting(file,"dbuser=\"#{input}\"\n")
    end
#dbpass
    uinput = agree("database USER PASS, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"dbpass=\"devsqluser\"\n")
    else
        input = ask("database password:")
        mi.add_setting(file,"dbuser=\"#{input}\"\n")
    end
#install sample data
    puts "SAMPLE DATA *** would you like to install this?[y/n]"
    uinput = agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
    if uinput
        mi.add_setting(file,"install_sample=\"true\"\n")
    else
        mi.add_setting(file,"install_sample=\"false\"\n")
    end

#use ldap
    uinput = agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: n', :bold, :yellow, :on_black) %>")
    if uinput
        mi.add_setting(file,"use_ldap\"true\"\n")
    else
        mi.add_setting(file,"use_ldap=\"false\"\n")
    end
######
    
#add your nid for LDAP based tests
    uinput = ask("Add your own personal user?[y/n]  <%= color('*** the default user is still installed ***', :bold, :yellow, :on_black) %>") { |q| q.validate = /\A[y|n]\Z/ }
    
    if uinput == 'y'
        
        uinput = ask("<%= color('*** This must be your NID if using LDAP ***', :bold, :yellow, :on_black) %>\nUsername:") do |q| 
                    q.validate = /\A\w+\Z/
                    q.responses[:not_valid]    = 'Must not be blank'
                    q.responses[:ask_on_error] = :question
                end
        if uinput != ''
            mi.add_setting(file,"custom_adminuser=\"#{uinput}\"\n")
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
        mi.add_setting(file,"custom_adminpass=\"#{pass}\"\n")

#first name
        uinput = ask("First name:") { |q| q.validate = /\A\w+\Z/ }
        if uinput != ''
            mi.add_setting(file,"custom_adminfname=\"#{uinput}\"\n")
        end  
        
#last name
        uinput = ask("Last name:") { |q| q.validate = /\A\w+\Z/ }
        if uinput != ''
            mi.add_setting(file,"custom_adminlname=\"#{uinput}\"\n")
        end  
#email
        uinput = ask("Email:") { |q| 
            q.validate  = mi.test_email
            q.responses[:not_valid]    = "<%= color('you must use a valid email.', :bold, :red, :on_black) %>"
        }
        if uinput != ''
            mi.add_setting(file,"custom_adminlemail=\"#{uinput}\"\n")
        end  
    end
    
    
    mi.add_setting(file,"adminuser=\"admin\"\n")
    mi.add_setting(file,"adminpass=\"admin2013\"\n")
    mi.add_setting(file,"adminfname=\"MC\"\n")
    mi.add_setting(file,"adminlname=\"Lovin\"\n")
    mi.add_setting(file,"adminemail=\"test.user@wsu.edu\"\n")

    puts "the installer setting have been created"
end



