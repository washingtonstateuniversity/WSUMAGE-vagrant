#todo fix the mi_h = MAGEINSTALLER_Helper.new need
require 'rubygems'

class MageInstaller
    load 'rake/helper.rb'
    fresh=false
    def initialize(params=nil)
        if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.8')
            require 'fileutils'
            self.load_gem("json")
            self.load_gem("highline")
            self.load_gem("launchy")
            if @fresh
                puts "there were a few things needed to install so you need to do `rake start` again."
                abort("type rake start")
                return
            else
                require 'highline/import'
            end
        else         
            abort("ruby version to low, must update see http://rvm.io/ if on Mac")
        end
    end

    def load_gems(utility=nil)
        #foreach here
    end    
    def load_gem(gem=nil)
        output = `gem list`
        sudo=""  
        is_windows = (ENV['OS'] == 'Windows_NT')
        if !is_windows
            sudo="sudo"    
        end
        if !output.include? gem
            puts "installing #{gem} gem"
            output = `#{sudo} gem install #{gem}`
            puts output
            @fresh=true
        else
            if @fresh
                puts "#{gem} gem loaded"
            end
        end
    end

##################    
#tasks
##################

#test
    def test()
        mi_h = MAGEINSTALLER_Helper.new
        puts "testing the system now"
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
    
    
    
    #REFACTOR THIS LATER
    def load_settings()
        require 'json'
        file = File.open("scripts/installer_settings.json", "rb")
        contents = file.read
        file.close
        if contents.length > 5 #note this should be changed for a better content check.. ie:valid json
            begin
                parsed = JSON.parse(contents)
            rescue SystemCallError
                puts "must redo the settings file"
            else    
                puts parsed['bs_mode']
                parsed.each do |key, value|
                    puts key
                    puts value
                end
            end
        else
            puts "must redo the settings file"
        end
    end
    def begin_settings_file()
        mi_h = MAGEINSTALLER_Helper.new
        file="scripts/installer_settings.json"
        FileUtils.rm_rf(file)
        mi_h.add_setting(file,"{") 
    end
    
    def end_settings_file()
        mi_h = MAGEINSTALLER_Helper.new
        file_path="scripts/installer_settings.json"
        file = File.open(file_path, "rb") #opeing as bin for ease
        contents = file.read
        contents = contents.gsub(/,+$/, '')
        
        file.close
        file = File.open(file_path, "w") #reopen forstr ops
            file.write(contents)
        file.close
        mi_h.add_setting(file,"}") 
    end
    
    

#start
    def start()
        mi_h = MAGEINSTALLER_Helper.new
        stopwatch = Stopwatch.new
        Rake::Task["test"].reenable
        Rake::Task["test"].invoke
        self.load_settings()#maybe more global?
        mi_h.get_pre_task()
        uinput = agree("Use last run's set up? <%= color('[y/n]', :bold) %>")
        if uinput
            system( "vagrant up" )
        else
            new_mode = ask("Use development <%= color('lite', :bold) %> OR production <%= color('match', :bold) %>?  <%= color('[l/m]', :bold) %>  ") do |q|
              q.validate                 = /\Al(?:ite)?|m(?:atch)?\Z/i
              q.responses[:not_valid]    = 'Please enter "l" or "m" (lite|match).'
              q.responses[:ask_on_error] = :question
            end
            #todo still basicly add a global lite or match?
            if new_mode=="l"||new_mode=="lite" #change to the regex version?
                puts "working on the lite mode"
                FileUtils.cp_r('Vagrantfile-lite', 'Vagrantfile')
                mode = "lite"
            else
                FileUtils.cp_r('Vagrantfile-match', 'Vagrantfile')
                mode = "match"
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
            target  = "scripts/installer_settings.json"
            file = File.join(Dir.pwd, target)
            if File.exist?(file)
                uinput = agree("Should we clear the past install settings file?  <%= color('[y/n]', :bold) %>")
                if uinput
                    FileUtils.rm_rf(file)
                    say("<%= color('removed file #{file}', :bold, :red, :on_black) %>")
                    self.begin_settings_file()
                        mi_h.add_setting(file,"\"bs_mode\":\"#{mode}\",")         
                        Rake::Task["create_install_settings"].reenable
                        Rake::Task["create_install_settings"].invoke
                    self.end_settings_file()
                  else
                    puts "using the past installer settings"
                end
            else
                self.begin_settings_file()
                    mi_h.add_setting(file,"\"bs_mode\":\"#{mode}\",")    
                    Rake::Task["create_install_settings"].reenable
                    Rake::Task["create_install_settings"].invoke
                self.end_settings_file()
            end
            
            
            say("[<%= color('Starting the Vagrant', :bold,:red) %>]")
            
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
    
        file="scripts/installer_settings.json"
        mi_h.add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
#use defaults?
        uinput = agree("use default settings? <%= color('[y/n]', :bold) %>? ")
        if uinput
            self.set_settings_defaults()
        else
    #url
            input = ask("Site Url:")
            mi_h.add_setting(file,"\"bs_url\":\"#{input}\",")   
    #host
            input = ask("database host:")
            mi_h.add_setting(file,"\"bs_dbhost\":\"#{input}\",")
    #dbname
            input = ask("database name:")
            mi_h.add_setting(file,"\"bs_dbname\":\"#{input}\",")
    #dbuser
            input = ask("database user:")
            mi_h.add_setting(file,"\"bs_dbuser\":\"#{input}\",")
    #dbpass
            input = ask("database password:")
            mi_h.add_setting(file,"\"bs_dbuser\":\"#{input}\",")
        end
        
#install sample data
        #only if we are in lite mode.  Match would have the products?  or maybe to much?
        puts "SAMPLE DATA *** would you like to install this?[y/n]"
        uinput = agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
        if uinput
            mi_h.add_setting(file,"\"bs_install_sample\":\"true\",")
        else
            mi_h.add_setting(file,"\"bs_install_sample\":\"false\",")
        end
    
#use ldap
        uinput = agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: must be within network', :bold, :yellow, :on_black) %>")
        if uinput
            mi_h.add_setting(file,"\"bs_use_ldap\":\"true\",")
        else
            mi_h.add_setting(file,"\"bs_use_ldap\":\"false\",")
        end
    ######
    
        self.set_custom_user_settings()

        #default user must be there
        mi_h.add_setting(file,"\"bs_adminuser\":\"admin\",")
        mi_h.add_setting(file,"\"bs_adminpass\":\"admin2013\",")
        mi_h.add_setting(file,"\"bs_adminfname\":\"MC\",")
        mi_h.add_setting(file,"\"bs_adminlname\":\"Lovin\",")
        mi_h.add_setting(file,"\"bs_adminemail\":\"test.user@wsu.edu\",")      
    end


    def set_settings_defaults()
        mi_h = MAGEINSTALLER_Helper.new
        require 'digest/md5'
        file="scripts/installer_settings.json"
        mi_h.add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
        mi_h.add_setting(file,"\"bs_url\":\"local.mage.dev\",")
        mi_h.add_setting(file,"\"bs_dbhost\":\"localhost\",") # if in lite mode then 
        mi_h.add_setting(file,"\"bs_dbname\":\"mage\",")
        mi_h.add_setting(file,"\"bs_dbuser\":\"devsqluser\",")
        mi_h.add_setting(file,"\"bs_dbpass\":\"devsqluser\",")
    end

    def set_custom_user_settings()
        mi_h = MAGEINSTALLER_Helper.new
        require 'digest/md5'
        file="scripts/installer_settings.json"
#add your nid for LDAP based tests
        uinput = agree("Add your own personal user?[y/n]  <%= color('*** the default user is still installed ***', :bold, :yellow, :on_black) %>")
        if uinput
            uinput = ask("<%= color('*** This must be your NID if using LDAP ***', :bold, :yellow, :on_black) %>\nUsername:") do |q| 
                        q.validate = /.+/ 
                        q.responses[:not_valid]    = 'Must not be blank'
                        q.responses[:ask_on_error] = :question
                    end
            if uinput != ''
                mi_h.add_setting(file,"\"bs_custom_adminuser\":\"#{uinput}\",")
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
            mi_h.add_setting(file,"\"bs_custom_adminpass\":\"#{pass}\",")
    
    #first name
            uinput = ask("First name:") do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            mi_h.add_setting(file,"\"bs_custom_adminfname\":\"#{uinput}\",")
            
    #last name
            uinput = ask("Last name:")  do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            mi_h.add_setting(file,"\"bs_custom_adminlname\":\"#{uinput}\",")
     
    #email
            uinput = ask("Email:") { |q| 
                q.validate  = mi_h.test_email
                q.responses[:not_valid]    = "<%= color('you must use a valid email.', :bold, :red, :on_black) %>"
            }
            mi_h.add_setting(file,"\"bs_custom_adminlemail\":\"#{uinput}\",")
     
        end
    end


end