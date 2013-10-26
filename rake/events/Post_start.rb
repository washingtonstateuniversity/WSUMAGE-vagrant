#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Post_start
    include MAGEINSTALLER_Helper
    def initialize(params=nil)
        load_settings
        if agree("Would you like to package this box? <%= color('[y/n]', :bold) %>")
            system("vagrant package --base weblite --output _BOXES/weblite_alt.box")
            system("vagrant box add weblite_alt _BOXES/weblite_alt.box")
        end
    end
end