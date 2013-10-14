#the goal of this file is that you 
#build your total production server
#with options

##note not happy with the start init loop, work on that
load 'rake/installer.rb'

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
    MageInstaller.new.init()
end

desc "test  the system"
task :test do
    MageInstaller.new.test()
end


desc "Set up the VM with questions"
task :start do
    MageInstaller.new.start()
end

desc "Destroy the vagrant with call back functions run"
task :end do
    MageInstaller.new.end()
end






desc "here to provide consistency  with Vagrant, that and adds a timer and pre/post events"
task :up do
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
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    system( "vagrant reload" )
    mi_h.get_post_task()
    stopwatch.end
end

#note just for testing/ like a bonus
task :open do
    stopwatch = Stopwatch.new
    mi_h.get_pre_task()
    require 'launchy'
    Launchy.open("http://local.mage.dev/admin") #note this should be from setting file
    
    mi_h.get_post_task()
    stopwatch.end
end




#these should maybe be extracted out?
task :hardclean do
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

desc "clean the database"
task :clean_db do
  puts "cleaning the database"
  FileUtils.rm_rf(Dir.glob('database/data/*'))
  puts "database is clean"
end

#maybe abstract this of other apps
desc "clean the database"
task :clean_www do
  puts "cleaning the WWW folder"
  FileUtils.rm_rf(Dir.glob('www/*'))
  puts "The WWW has been cleaned"
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



