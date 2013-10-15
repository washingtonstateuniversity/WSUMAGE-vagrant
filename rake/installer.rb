#todo fix the mi_h = MAGEINSTALLER_Helper.new need


class MageInstaller
    load 'rake/helper.rb'
    def initialize(params=nil)
        require 'fileutils'
        self.load_gem("highline")
        self.load_gem("launchy")
        require 'highline'
    end

    def load_gems(utility=nil)
        #foreach here
    end    
    def load_gem(gem=nil)
        output = `gem list`
        if !output.include? gem
            puts "installing #{gem} gem"
            output = `gem install #{gem}`
            puts output
            fresh=true
        else
            puts "highline #{gem} loaded"
        end
    end

##################    
#tasks
##################
    
#init
    def init()
        mi_h = MAGEINSTALLER_Helper.new
        stopwatch = Stopwatch.new
        mi_h.get_pre_task()
    
        Rake::Task["test"].reenable
        Rake::Task["test"].invoke
        
        mi_h.get_post_task()
        stopwatch.end
    
        puts "> We have settup everything, only last"
        puts "> thing to do when ready is `rake start`"
        uinput = agree("Would you like to start? <%= color('[y/n]', :bold) %>")
        if uinput
            #Rake::Task["start"].reenable
            #Rake::Task["start"].invoke
            self.start()
        end
    end
#test
    def test()
        mi_h = MAGEINSTALLER_Helper.new
        say("testing the system now")
        fresh=false
        puts "insuring default folders"
        mi_h.create_dir("/www/")
        mi_h.create_dir("/_BOXES/")
        mi_h.create_dir("/database/data/")
        #this is where we would build the Vagrant file to suite if abstracted to account for 
        #more then this project    
        file='_BOXES/precise32.box'
        if !File.exist?(file)
            mi_h.download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box',file)
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
    end
    
#start
    def start()
        mi_h = MAGEINSTALLER_Helper.new
        stopwatch = Stopwatch.new
        Rake::Task["test"].reenable
        Rake::Task["test"].invoke
        mi_h.get_pre_task()
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
            if mode=="l"||mode=="lite"
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

                    mi_h.start_settings_file()
                    mi_h.add_setting(file,"bs_mode=\"#{mode}\"\n")         
 
                    Rake::Task["create_install_settings"].reenable
                    Rake::Task["create_install_settings"].invoke
                  else
                    puts "using the past installer settings"
                end
            else
                mi_h.start_settings_file()
                mi_h.add_setting(file,"bs_mode=\"#{mode}\"\n")    
                Rake::Task["create_install_settings"].reenable
                Rake::Task["create_install_settings"].invoke
            end
            
            
            say("Finished lets go [press <%= color('enter', :bold) %> to continue]")

            system( "vagrant up" )
        end
    
        mi_h.get_post_task()
        stopwatch.end
    
        Rake::Task["open"].reenable
        Rake::Task["open"].invoke  
    end
    
#end
    def end()
        mi_h = MAGEINSTALLER_Helper.new
        stopwatch = Stopwatch.new
        mi_h.get_pre_task()
        system( "vagrant destroy -f" )
        uinput = agree("Should all the databases be cleared?   <%= color('[y/n]', :bold) %>")
        if uinput
            Rake::Task["clean_db"].reenable
            Rake::Task["clean_db"].invoke
        end
        
        mi_h.get_post_task()
        stopwatch.end
    end
    

#hardclean
    def hardclean()
        mi_h = MAGEINSTALLER_Helper.new
        stopwatch = Stopwatch.new
        mi_h.get_pre_task()
        output=`vagrant destroy -f`
        puts output
        Rake::Task["clean_www"].reenable
        Rake::Task["clean_www"].invoke   
    
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
        
        mi_h.get_post_task()
        stopwatch.end
    end


#setting file
    def create_settings_file()
        mi_h = MAGEINSTALLER_Helper.new
        require 'digest/md5'
    
        file="scripts/install_settings.sh"
        mi_h.add_setting(file,"bs_MAGEversion=\"1.8.0.0\"\n")
        mi_h.add_setting(file,"bs_url=\"local.mage.dev\"\n")
    
    #host
        uinput = agree("database HOST, use the default <%= color('`localhost`', :bold) %>? [y/n]")
        if uinput
            #maybe check vagrant? if not lets go the hard coded, but for now we'll localhost
            mi_h.add_setting(file,"bs_dbhost=\"localhost\"\n")
        else
            input = ask("database host:")
            mi_h.add_setting(file,"bs_dbhost=\"#{input}\"\n")
        end
    #dbname
        uinput = agree("database NAME, use the default <%= color('`mage`', :bold) %>? [y/n]")
        if uinput
            mi_h.add_setting(file,"bs_dbname=\"mage\"\n")
        else
            mi_h.add_setting(file,"bs_dbname=\"#{uinput}\"\n")
        end
    #dbuser
        uinput = agree("database USER, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
        if uinput
            mi_h.add_setting(file,"bs_dbuser=\"devsqluser\"\n")
        else
            input = ask("database user:")
            mi_h.add_setting(file,"bs_dbuser=\"#{input}\"\n")
        end
    #dbpass
        uinput = agree("database USER PASS, use the default <%= color('`devsqluser`', :bold) %>? [y/n]")
        if uinput
            mi_h.add_setting(file,"bs_dbpass=\"devsqluser\"\n")
        else
            input = ask("database password:")
            mi_h.add_setting(file,"bs_dbuser=\"#{input}\"\n")
        end
    #install sample data
        #only if we are in lite mode.  Match would have the products?  or maybe to much?
        puts "SAMPLE DATA *** would you like to install this?[y/n]"
        uinput = agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
        if uinput
            mi_h.add_setting(file,"bs_install_sample=\"true\"\n")
        else
            mi_h.add_setting(file,"bs_install_sample=\"false\"\n")
        end
    
    #use ldap
        uinput = agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: must be within network', :bold, :yellow, :on_black) %>")
        if uinput
            mi_h.add_setting(file,"bs_use_ldap\"true\"\n")
        else
            mi_h.add_setting(file,"bs_use_ldap=\"false\"\n")
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
                mi_h.add_setting(file,"bs_custom_adminuser=\"#{uinput}\"\n")
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
            mi_h.add_setting(file,"bs_custom_adminpass=\"#{pass}\"\n")
    
    #first name
            uinput = ask("First name:") do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            mi_h.add_setting(file,"bs_custom_adminfname=\"#{uinput}\"\n")
            
    #last name
            uinput = ask("Last name:")  do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            mi_h.add_setting(file,"bs_custom_adminlname=\"#{uinput}\"\n")
     
    #email
            uinput = ask("Email:") { |q| 
                q.validate  = mi_h.test_email
                q.responses[:not_valid]    = "<%= color('you must use a valid email.', :bold, :red, :on_black) %>"
            }
            mi_h.add_setting(file,"bs_custom_adminlemail=\"#{uinput}\"\n")
     
        end
        
        #default user must be there
        mi_h.add_setting(file,"bs_adminuser=\"admin\"\n")
        mi_h.add_setting(file,"bs_adminpass=\"admin2013\"\n")
        mi_h.add_setting(file,"bs_adminfname=\"MC\"\n")
        mi_h.add_setting(file,"bs_adminlname=\"Lovin\"\n")
        mi_h.add_setting(file,"bs_adminemail=\"test.user@wsu.edu\"\n")
    
        puts "the installer setting have been created" 
            
            
            
            
    end









end