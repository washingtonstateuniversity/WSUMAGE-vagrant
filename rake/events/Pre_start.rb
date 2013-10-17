#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Pre_start
    include MAGEINSTALLER_Helper
    def initialize(params=nil)
        puts 'World'
        
        load_settings
        version = @bs_MAGEversion
        if version==nil
            uinput = agree("There was no config, would you like to use the 1.8.0 version of Magento <%= color('[y/n]', :bold) %>")
            if uinput
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
                File.open("#{Dir.pwd}/www/magento/installed.txt", "w+") { |file| file.write("") }
            end
        end
        file="_depo/magento-sample-data-1.6.1.0.tar.gz"
        if !File.exist?(file)
            download("http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz",file)
        else
            puts "mage sample data package exists"
        end
    end
end