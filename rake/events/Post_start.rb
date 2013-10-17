#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Post_start
    include MAGEINSTALLER_Helper
    def initialize(params=nil)
        load_settings
        uinput = agree("Would you like to package this box? <%= color('[y/n]', :bold) %>")
        if uinput
            system("vagrant package precise32 precise32_alt --precise32_alt.box")
            system("vagrant box add precise32_alt precise32_alt.box")
        end
    end
end