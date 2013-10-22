#right now this is geared to a Magento dev env. here but with a little more 
#refactoring we will be able to have this handle a few types like WP to more 
#complicated ones.

#is there room to improve adn abstract this, yes!  throw ideas out adn let us see what sticks


require 'rubygems'
class MageInstaller
    
    load 'rake/helper.rb'
    include MAGEINSTALLER_Helper
    
    fresh=false
    
    def initialize(params=nil)
        if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.8')
            require 'fileutils'
            self.load_gem("json")
            self.load_gem("highline")
            self.load_gem("launchy")
            output = `vagrant plugin list`
            if !output.include? "vagrant-hostsupdater"
                puts "installing vagrant-hostsupdater plugin"
                puts `vagrant plugin install vagrant-hostsupdater`
            else
                if @fresh
                    puts "vagrant-hostsupdater plugin loaded"
                end
            end
            if !output.include? "vagrant-cachier"
                puts "installing vagrant-cachier plugin"
                puts `vagrant plugin install vagrant-cachier`
            else
                if @fresh
                    puts "vagrant-cachier plugin loaded"
                end
            end
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
        puts "testing the system now"
        fresh=false
        puts "insuring default folders"
        create_dir("/www/")
        create_dir("/_depo/")
        create_dir("/_BOXES/")
        create_dir("/database/data/")
        if !File.exist?("#{Dir.pwd}/scripts/installer_settings.json") 
            File.open("#{Dir.pwd}/scripts/installer_settings.json", "w+") { |file| file.write("") }
        end
        #this is where we would build the Vagrant file to suite if abstracted to account for 
        #more then this project would allow for new boxes is approprate too.  
        file="#{Dir.pwd}/_BOXES/precise32.box"
        if !File.exist?(file)
            download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box',file)
        else
            puts "base box esited"
        end
        say("System seems ready <%= color('proceeding forward', :bold) %>")
    end

#start
    def start()
        stopwatch = Stopwatch.new

        self.test()
         
        load_settings()
        get_pre_task()
        
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
            #needs to ask questions oh the servers first being to use defaults?
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
                    #Rake::Task["clean_www"].reenable
                    #Rake::Task["clean_www"].invoke
                    self.clean_www()
                end
            end
    #database
            if Dir['database/data/*'].empty?
                uinput = agree("Should all the databases be cleared? <%= color('[y/n]', :bold) %>")
                if uinput
                    #Rake::Task["clean_db"].reenable
                    #Rake::Task["clean_db"].invoke
                    self.clean_db()
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
                    begin_settings_file()
                        add_setting(file,"\"bs_mode\":\"#{mode}\",")         
                        #Rake::Task["create_install_settings"].reenable
                        #Rake::Task["create_install_settings"].invoke
                        self.create_settings_file()
                    end_settings_file()
                  else
                    puts "using the past installer settings"
                end
            else
                begin_settings_file()
                    add_setting(file,"\"bs_mode\":\"#{mode}\",")    
                    #Rake::Task["create_install_settings"].reenable
                    #Rake::Task["create_install_settings"].invoke
                    self.create_settings_file()
                end_settings_file()
            end
            
            load_settings()
            if @bs_install_sample
                file="_depo/magento-sample-data-1.6.1.0.tar.gz"
                if File.exist?(file)
                    if !File.exist?("#{Dir.pwd}/www/magento/sample_installed.txt") 
                        puts "extracting mage package contents"
                        untar_gz(file,"www/magento")
                        File.open("#{Dir.pwd}/www/magento/sample_installed.txt", "w+") { |file| file.write("") }
                    end
                end
            end
            
            say("[<%= color('Starting the Vagrant', :bold,:green) %>]")
            
            system( "vagrant up" )
        end
        self.open()
        get_post_task()
        stopwatch.end
    end
    
#end
    def end()
        stopwatch = Stopwatch.new
        get_pre_task()
        system( "vagrant destroy -f" )
        uinput = agree("Should all the databases be cleared?   <%= color('[y/n]', :bold) %>")
        if uinput
            Rake::Task["clean_db"].reenable
            Rake::Task["clean_db"].invoke
        end
        get_post_task()
        stopwatch.end("finished shutdown in:")
    end

#clean_db
    def clean_db()
        puts "cleaning the database"
        FileUtils.rm_rf(Dir.glob('database/data/*'))
        puts "database is clean"
    end

#clean_www
    def clean_www()
        puts "cleaning the WWW folder"
        FileUtils.rm_rf(Dir.glob('www/*'))
        puts "The WWW has been cleaned"
    end

#fresh
    def fresh()
        self.hardclean()
        puts "needs to uninstall gems and what not"
    end


#hardclean
    def hardclean()
        stopwatch = Stopwatch.new
        get_pre_task()
        output=`vagrant destroy -f`
        puts output
        Rake::Task["clean_www"].reenable
        Rake::Task["clean_www"].invoke   
    
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
        
        puts "cleaning the depo folder"
        FileUtils.rm_rf(Dir.glob('depo/*'))
        puts "The depo has been cleaned"
        
        
        get_post_task()
        stopwatch.end("finished hard clean up in:")
    end

#open
    def open()
        
        #note we would want to check for the browser bing open already
        #so we don't annoy people
        
        get_pre_task()
        require 'launchy'
        Launchy.open("http://local.mage.dev/admin") #note this should be from setting file
        get_post_task()
    end


#up
    def up()
        stopwatch = Stopwatch.new
        self.test()
        load_settings()
        get_pre_task()
        system( "vagrant up" )
        get_post_task()
        stopwatch.end("box brought up in:")
        self.open()
    end

#reload
    def reload()
        stopwatch = Stopwatch.new
        get_pre_task()
        system( "vagrant reload" )
        get_post_task()
        stopwatch.end("reloaded in:")
        self.open()
    end

#destroy
    def destroy()
        stopwatch = Stopwatch.new
        get_pre_task()
        system( "vagrant destroy" )
        get_post_task()
        stopwatch.end
    end

#halt
    def halt()
        stopwatch = Stopwatch.new
        get_pre_task()
        system( "vagrant halt" )
        get_post_task()
        stopwatch.end
    end

#restart
    def restart()
        stopwatch = Stopwatch.new
        get_pre_task()
        self.end()
        self.up()
        get_post_task()
        stopwatch.end("restarted in:")
    end




#setting file
    def create_settings_file()

        require 'digest/md5'
    
        file="scripts/installer_settings.json"
        add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
#use defaults?
        uinput = agree("use default settings? <%= color('[y/n]', :bold) %>? ")
        if uinput
            self.set_settings_defaults()
        else
    #url
            input = ask("Site Url:")
            add_setting(file,"\"bs_url\":\"#{input}\",")   
    #host
            input = ask("database host:")
            add_setting(file,"\"bs_dbhost\":\"#{input}\",")
    #dbname
            input = ask("database name:")
            add_setting(file,"\"bs_dbname\":\"#{input}\",")
    #dbuser
            input = ask("database user:")
            add_setting(file,"\"bs_dbuser\":\"#{input}\",")
    #dbpass
            input = ask("database password:")
            add_setting(file,"\"bs_dbuser\":\"#{input}\",")
        end
        
#install sample data
        #only if we are in lite mode.  Match would have the products?  or maybe to much?
        puts "SAMPLE DATA *** would you like to install this?[y/n]"
        uinput = agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
        if uinput
            add_setting(file,"\"bs_install_sample\":\"true\",")
        else
            add_setting(file,"\"bs_install_sample\":\"false\",")
        end
    
#use ldap
        uinput = agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: must be within network', :bold, :yellow, :on_black) %>")
        if uinput
            add_setting(file,"\"bs_use_ldap\":\"true\",")
        else
            add_setting(file,"\"bs_use_ldap\":\"false\",")
        end
    ######
    
        self.set_custom_user_settings()

        #default user must be there
        add_setting(file,"\"bs_adminuser\":\"admin\",")
        add_setting(file,"\"bs_adminpass\":\"admin2013\",")
        add_setting(file,"\"bs_adminfname\":\"MC\",")
        add_setting(file,"\"bs_adminlname\":\"Lovin\",")
        add_setting(file,"\"bs_adminemail\":\"test.user@wsu.edu\",")      
    end


    def set_settings_defaults()
        require 'digest/md5'
        file="scripts/installer_settings.json"
        add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
        add_setting(file,"\"bs_url\":\"local.mage.dev\",")
        add_setting(file,"\"bs_dbhost\":\"localhost\",") # if in lite mode then 
        add_setting(file,"\"bs_dbname\":\"mage\",")
        add_setting(file,"\"bs_dbuser\":\"devsqluser\",")
        add_setting(file,"\"bs_dbpass\":\"devsqluser\",")
    end

    def set_custom_user_settings()

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
                add_setting(file,"\"bs_custom_adminuser\":\"#{uinput}\",")
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
            add_setting(file,"\"bs_custom_adminpass\":\"#{pass}\",")
    
    #first name
            uinput = ask("First name:") do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            add_setting(file,"\"bs_custom_adminfname\":\"#{uinput}\",")
            
    #last name
            uinput = ask("Last name:")  do |q| 
                q.validate = /.+/ 
                q.responses[:not_valid]    = 'Must not be blank'
                q.responses[:ask_on_error] = :question
            end
            add_setting(file,"\"bs_custom_adminlname\":\"#{uinput}\",")
     
    #email
            uinput = ask("Email:") { |q| 
                q.validate  = test_email
                q.responses[:not_valid]    = "<%= color('you must use a valid email.', :bold, :red, :on_black) %>"
            }
            add_setting(file,"\"bs_custom_adminlemail\":\"#{uinput}\",")
     
        end
    end


end