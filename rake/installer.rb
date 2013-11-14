#right now this is geared to a Magento dev env. here but with a little more 
#refactoring we will be able to have this handle a few types like WP to more 
#complicated ones.

# is there room to improve andabstract this, yes!  
# throw ideas out and let us see what sticks

require 'rubygems'
module MageInstaller
    
    load 'rake/helper.rb'
    include MAGEINSTALLER_Helper
    
    fresh=false
    
    def initialize(params=nil)
        if !File.exist?("#{Dir.pwd}/READY") 
            if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.8')
                puts "initializing the system"          
                load_gem("json")
                load_gem("highline")
                load_gem("launchy")
                output = `vagrant plugin list`
                if !output.include? "vagrant-hostsupdater"
                    puts "installing vagrant-hostsupdater plugin"
                    puts `vagrant plugin install vagrant-hostsupdater`
                else
                    puts "vagrant-hostsupdater plugin loaded"
                end
                if !output.include? "vagrant-cachier"
                    puts "installing vagrant-cachier plugin"
                    puts `vagrant plugin install vagrant-cachier`
                else
                    puts "vagrant-cachier plugin loaded"
                end
                 if !output.include? "vagrant-vbguest"
                    puts "installing vagrant-vbguest plugin"
                    puts `vagrant plugin install vagrant-vbguest`
                else
                    puts "vagrant-cachier plugin loaded"
                end               
            
                puts "*************************************************************\n"
                puts "`rake start` again ******************************************\n"
                puts " there were a few things needed to install so you need to do."
                puts "*************************************************************\n"
                File.open("#{Dir.pwd}/READY", "w+") { |file| file.write("") }
                abort("type rake start")
            else         
                abort("ruby version to low, must update see http://rvm.io/ if on Mac")
            end
        else
            require 'highline/import'
        end
    end



##################    
#tasks
##################

#test
    def test()
        require 'fileutils'

        puts "testing the system now"
        fresh=false
        puts "insuring default folders"
        create_dir("/www/")
        create_dir("/www/magento/")
        create_dir("/www/magento/maps/")
        create_dir("/_depo/")
        create_dir("/_BOXES/")
        create_dir("/database/data/")
        if !File.exist?("#{Dir.pwd}/scripts/installer_settings.json") 
            File.open("#{Dir.pwd}/scripts/installer_settings.json", "w+") { |file| file.write("") }
        end
        #this is where we would build the Vagrant file to suite if abstracted to account for 
        #more then this project would allow for new boxes is approprate too.  
        file="#{Dir.pwd}/_BOXES/precise32.box"
        if !File.exist?(file) && agree("Should we bring the box local?   <%= color('[y/n]', :bold) %>")
            download('http://images.wsu.edu/vmboxes/precise32.box',file)
            if !File.exist?(file) #fall back
                download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box',file)
            else
                puts "base box esited"
            end
        else
            puts "base box esited"
        end
        say("System seems ready <%= color('proceeding forward', :bold) %>")
    end

#start
    def start()
        stopwatch = Stopwatch.new
        self.test()
        event("Pre")

        say("[<%= color('Starting the Vagrant', :bold,:green) %>]")
        system( "vagrant up" )
        
        event("Post")
        self.open() 
        stopwatch.end("Started in:")
    end
    
#end
    def end_it()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant destroy -f" )
        if agree("Should all the databases be cleared?   <%= color('[y/n]', :bold) %>")
            self.clean_db()
        end
        event("Post")
        stopwatch.end("finished shutdown in:")
    end

#clean_db
    def clean_db()
        say("<%= color('starting database removal', :bold, :yellow, :on_black) %>")
        #note maybe nuking can be done a simpler way to preserve the db install it's self?
        FileUtils.rm_rf(Dir.glob('database/data/*'))
        
        FileUtils.rm_rf(Dir.glob('www/*/mageinstalled.sql'))
        
        say("<%= color('mysql is fully cleared', :bold, :red, :on_black) %>")
    end

#clean_www
    def clean_www()
        say("<%= color('cleaning the WWW folder', :bold, :yellow, :on_black) %>")
        FileUtils.rm_rf(Dir.glob('www/*'))
        say("<%= color('all files in the www web root has been cleared', :bold, :red, :on_black) %>")
    end

#fresh
    def fresh()
        self.hardclean()
        puts "needs to uninstall gems and what not"
    end


#hardclean
    def hardclean()
        stopwatch = Stopwatch.new
        event("Pre")
        output=`vagrant destroy -f`
        puts output

        self.clean_www()
        self.clean_db()
        if agree("Should the Package Depo be cleared as well?   <%= color('[y/n]', :bold) %>")
            say("<%= color('cleaning the file DEPO folder', :bold, :yellow, :on_black) %>")
            FileUtils.rm_rf(Dir.glob("#{Dir.pwd}/_depo/*"))
            say("<%= color('all files in the _depo web root has been cleared', :bold, :red, :on_black) %>")
        end

        event("Post")
        stopwatch.end("finished hard clean up in:")
    end


#this should be removed so that we can do better with this
#open
    def open()
        
        #note we would want to check for the browser bing open already
        #so we don't annoy people
        
        event("Pre")
        require 'launchy'
        Launchy.open("http://store.mage.dev/admin") #note this should be from setting file
        event("Post")
    end


#up
    def up()
        stopwatch = Stopwatch.new
        self.test()
        load_settings()
        event("Pre")
        system( "vagrant up" )
        event("Post")
        self.open()
        stopwatch.end("box brought up in:")
        
    end

#reload
    def reload()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant reload" )
        event("Post")
        self.open()
        stopwatch.end("reloaded in:")
    end

#destroy
    def destroy()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant destroy" )
        event("Post")
        stopwatch.end("destroy in:")
    end

#halt
    def halt()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant halt" )
        event("Post")
        stopwatch.end("halted in:")
    end

#restart
    def restart()
        stopwatch = Stopwatch.new
        event("Pre")
        self.end_it()
        self.up()
        event("Post")
        stopwatch.end("restarted in:")
    end




#setting file
    def create_settings_file()

        
        #we would call to each package adn if they exist
        #then we would run it's content, for example:
        require 'digest/md5'
    
        file="scripts/installer_settings.json"
        add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
#use defaults?
        if agree("use default settings? <%= color('[y/n]', :bold) %>? ")
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

        #default user must be there
        add_setting(file,"\"bs_adminuser\":\"admin\",")
        add_setting(file,"\"bs_adminpass\":\"admin2013\",")
        add_setting(file,"\"bs_adminfname\":\"MC\",")
        add_setting(file,"\"bs_adminlname\":\"Lovin\",")
        add_setting(file,"\"bs_adminemail\":\"test.user@wsu.edu\",")      


        
#install sample data
        #only if we are in lite mode.  Match would have the products?  or maybe to much?
        if agree("Install <%= color('`SAMPLE DATA`', :bold) %>? [y/n]")
            add_setting(file,"\"bs_install_sample\":\"true\",")

        else
            add_setting(file,"\"bs_install_sample\":\"false\",")
        end
    
#use ldap
        
        if agree("turn on <%= color('LDAP', :bold) %>? [y/n] <%= color('NOTE: must be within network', :bold, :yellow, :on_black) %>")
            add_setting(file,"\"bs_use_ldap\":\"true\",")
        else
            add_setting(file,"\"bs_use_ldap\":\"false\",")
        end
    ######
    
        self.set_custom_user_settings()


    end


    def set_settings_defaults()
        require 'digest/md5'
        file="scripts/installer_settings.json"
        add_setting(file,"\"bs_MAGEversion\":\"1.8.0.0\",")
        add_setting(file,"\"bs_url\":\"store.mage.dev\",")
        add_setting(file,"\"bs_dbhost\":\"localhost\",") # if in lite mode then 
        add_setting(file,"\"bs_dbname\":\"mage\",")
        add_setting(file,"\"bs_dbuser\":\"devsqluser\",")
        add_setting(file,"\"bs_dbpass\":\"devsqluser\",")
    end

    def set_custom_user_settings()

        require 'digest/md5'
        file="scripts/installer_settings.json"
#add your nid for LDAP based tests
        if agree("Add your own personal user?[y/n]  <%= color('*** the default user is still installed ***', :bold, :yellow, :on_black) %>")
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