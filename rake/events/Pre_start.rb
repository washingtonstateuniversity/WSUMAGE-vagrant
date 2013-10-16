#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Pre_start < MageInstaller
    def initialize(params=nil)
        puts 'World'
        
        mi_h = MAGEINSTALLER_Helper.new
        
        mi_h.load_settings()
        bs_MAGEversion=instance_variable_get("@bs_MAGEversion")
        file="www/depo/magento-#{bs_MAGEversion}.tar.gz"
        if !File.exist?(file)
            mi_h.download("http://www.magentocommerce.com/downloads/assets/#{bs_MAGEversion}/magento-#{bs_MAGEversion}.tar.gz",file)
        else
            puts "mage package exists"
        end

    end
end