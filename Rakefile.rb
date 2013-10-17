#the goal of this file is that you 
#build your total production server
#with options

##note not happy with the start init loop, work on that
load 'rake/installer.rb'
mi = MageInstaller.new
mode = "lite"

=begin
    Maybe what is needed is a first run type thing.  Test for everything
    task list
        :test #this is for testing that all the plugins are there, if not then install them?
        :open (more for testing) Opens up your default browser and loads your url from settings

        :init setup the system
        :start #vagrant up but with prompts
        :end #destroy with options to clean up

        :up #vagrant up (only adds timer and events)
        :destory #vagrant destory (only adds timer and events)
        :halt #vagrant halt (only adds timer and events)
        :reload #vagrant reload (only adds timer and events)
        :resume #vagrant resume (only adds timer and events)
        :suspend #vagrant suspend (only adds timer and events)

        :pull #match the local to the production
        :push #push up to production (would need to authenticate)

        :hardclean 
        :clean_db
        :clean_www
        :create_install_settings #create the settings for the installer
=end


desc "prepare  the system"
task :init do
    mi.init()
end

desc "test  the system"
task :test do
    mi.test()
end


desc "Set up the VM with questions"
task :start do
    mi.start()
end

desc "Destroy the vagrant with call back functions run"
task :end do
    mi.end()
end






desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :up do
    mi_h = MAGEINSTALLER_Helper.new
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    system( "vagrant up" )
    mi_h.get_post_task()
    stopwatch.end
    Rake::Task["open"].reenable
    Rake::Task["open"].invoke
end

desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :destroy do
    mi_h = MAGEINSTALLER_Helper.new
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    system( "vagrant destroy" )
    mi_h.get_post_task()
    stopwatch.end
end

desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :halt do
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    system( "vagrant halt" )
    mi_h.get_post_task()
    stopwatch.end
end

desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :reload do
    mi_h = MAGEINSTALLER_Helper.new
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    system( "vagrant reload" )
    mi_h.get_post_task()
    stopwatch.end
end

#note just for testing/ like a bonus
task :open do
    mi.open()
end




#these should maybe be extracted out?
task :hardclean do
    mi.hardclean()
end

desc "clean the database"
task :clean_db do
    mi.clean_db()
end

#maybe abstract this of other apps
desc "clean the web folder"
task :clean_www do
     mi.clean_www()
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
    MageInstaller.new.create_settings_file()
end



