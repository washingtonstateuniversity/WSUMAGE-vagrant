#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Pre_start
    include MAGEINSTALLER_Helper
    include MageInstaller
    def initialize(params=nil)
        
        load_settings
        version = @bs_MAGEversion
        if version==nil
            if agree("There was no config, would you like to use the 1.8.0.0 version of Magento <%= color('[y/n]', :bold) %>")
                version="1.8.0.0"
              else
                version = ask("version to use:")  do |q| 
                    q.validate = /.+/ 
                    q.responses[:not_valid]    = 'Must not be blank'
                    q.responses[:ask_on_error] = :question
                end
            end
        end
        
        file="_depo/magento-#{version}.tar.gz"
        if !File.exist?(file)
            download("http://www.magentocommerce.com/downloads/assets/#{version}/magento-#{version}.tar.gz",file)
        else
            puts "mage package exists"
        end
        
        if File.exist?(file)
            if !File.exist?("#{Dir.pwd}/www/magento/installed.txt") 
                puts "extracting mage package contents"
                untar_gz(file,"www")
                #note this is just untill i have the json working in fullness
                File.open("#{Dir.pwd}/www/magento/installed.txt", "w+") { |file| file.write("") }
            end
        end

        rerun=false
        file="#{Dir.pwd}/Vagrantfile"
        if File.exist?(file)
            if agree("Use last run's set up? <%= color('[y/n]', :bold) %>")
                rerun=true
            end
        end

        if !rerun
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
                if agree("Should WWW folder be cleared? <%= color('[y/n]', :bold) %>")
                    clean_www()
                end
            end
        #database
            if Dir['database/data/*'].empty?
                if agree("Should all the databases be cleared? <%= color('[y/n]', :bold) %>")
                    clean_db()
                end
            end
        #installer settings
            target  = "scripts/installer_settings.json"
            file = File.join(Dir.pwd, target)
            if File.exist?(file)
                if agree("Should we clear the past install settings file?  <%= color('[y/n]', :bold) %>")
                    FileUtils.rm_rf(file)
                    say("<%= color('removed file #{file}', :bold, :red, :on_black) %>")
                    begin_settings_file()
                        add_setting(file,"\"bs_mode\":\"#{mode}\",")         
                        create_settings_file()
                    end_settings_file()
                  else
                    puts "using the past installer settings"
                end
            else
                begin_settings_file()
                    add_setting(file,"\"bs_mode\":\"#{mode}\",")    
                    create_settings_file()
                end_settings_file()
            end
        end
    end
    
    def get_magepackage(version)

    end
    
    
    
end