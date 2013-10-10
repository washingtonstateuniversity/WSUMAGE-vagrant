#load 'rake/helper.rb'

class MAGEINSTALLER

  def add_setting(opts=nil)
    target  = "scripts/install_settings.sh"
    #content = <<-RUBY
    #  puts "I'm the target!"
    #RUBY
    
    File.open(target, "a+") do |f|
      f.write(opts)
    end
  end

    def download(from,to)
        mi =MAGEINSTALLER.new
    
        require 'net/http'
        require 'uri'

        counter = 0

        url_base = from.split('/')[2]
        url_path = '/'+from.split('/')[3..-1].join('/')
             
        puts "starting download for #{url_path}"
        Net::HTTP.start(url_base) do |http|
          begin
            file = open(to, 'wb')
            file.binmode

            http.request_get(url_path) do |response|
                size = 0
                total = response.header["Content-Length"].to_f
              response.read_body do |chunk|
                    file << chunk
                    counter += 1
                    size += chunk.size
                    new_progress = (size.to_f / total.to_f * 100.0).round(2)
                    progress = "#" * (new_progress / 10)
                    print "#{progress} --#{new_progress}%--\r"
                    #$stdout.flush
                  #sleep 0.005 
              end
            end
          ensure
            file.close
          end
        end
  
    end
  
    
    
end



=begin

    Maybe what is needed is a first run type thing.  Test for everything
    
    task list
        :test #this is for testing that all the plugins are there, if not then install them?
        :create_install_settings #create the settings for the installer
        :start #vagrant up but with prompts
        :end #destroy with options to clean up
        :pull #match the local to the production
        :push #push up to production (would need to authenticate)
        :clean_db
        :clean_mage_intsall
        :create_install_settings


=end

task :init do
    
    mi =MAGEINSTALLER.new
    mi.download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box','_BOXES/precise32.box')
    output = `vagrant init`
    puts output

end

task :test do
    puts "the lotion on the skin"

end



desc "Set up the VM"
task :start do

    mi =MAGEINSTALLER.new
    
    puts "Should past MAGE installs be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_mage_intsall"].reenable
        Rake::Task["clean_mage_intsall"].invoke
    end

    #should be testing first
    puts "Should the databases be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
    end


    puts "Should we clear the past install settings? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        target  = "scripts/install_settings.sh"
        FileUtils.rm_rf(target)
        puts "database is clean" 
          
        Rake::Task["create_install_settings"].reenable
        Rake::Task["create_install_settings"].invoke
          
          
      else
      puts "using the past installer settings"
    end


    exec 'vagrant up'   ## for now just start here but look to 
                        ## http://tech.natemurray.com/2007/03/ruby-shell-commands.html or
                        ## or try to get to vagrant CLI
end

desc "Destory the vagrant with call back functions run"
task :end do
    exec 'vagrant destroy -f'
    puts "Should the databases be cleared? [y/n]"
    input = STDIN.gets.strip
    if input == 'y'
        Rake::Task["clean_db"].reenable
        Rake::Task["clean_db"].invoke
    end

end



task :clean_db do
  puts "cleaning the database"
  FileUtils.rm_rf(Dir.glob('database/data/*'))
  puts "database is clean"
end

task :clean_mage_intsall do
  puts "cleaning the MAGE install"
  FileUtils.rm_rf(Dir.glob('www/mage/*'))
  puts "The Magento install has been removed"
end

task :deploy do
   puts "push to the server"
end

task :pull do
   puts "grabbing files and things"
end


task :create_install_settings do
    mi =MAGEINSTALLER.new

    #MAGEversion="1.8.0.0"
    #dbhost="localhost"
    #dbname="mage"
    #dbuser="devsqluser"
    #dbpass="devsqluser"
    #url="local.mage.dev"
    #adminuser="admin"
    #adminpass="admin2013"
    #adminfname="Mc"       
    #adminlname="Lovin"
    #adminemail="test.user@wsu.edu"
    mi.add_setting("#!/bin/bash\n")

    puts "What version of mage? [default 1.8.0.0]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("MAGEversion=\"1.8.0.0\"\n")
    else
        mi.add_setting("MAGEversion=\"input\"\n")
    end

    puts "database host of mage? [default localhost]"
    input = STDIN.gets.strip
    if input == ''
        #maybe check vagrant?
        #if not lets go the hard coded, but for
        #now we'll localhost
        mi.add_setting("dbhost=\"localhost\"\n")
    else
        mi.add_setting("dbhost=\"input\"\n")
    end

    puts "database name of mage? [default mage]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbname=\"mage\"\n")
    else
        mi.add_setting("dbname=\"input\"\n")
    end


    puts "database user of mage? [default devsqluser]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbuser=\"devsqluser\"\n")
    else
        mi.add_setting("dbuser=\"input\"\n")
    end

    puts "database user's password of mage? [default devsqluser]"
    input = STDIN.gets.strip
    if input == ''
        mi.add_setting("dbpass=\"devsqluser\"\n")
    else
        mi.add_setting("dbpass=\"input\"\n")
    end




    mi.add_setting("url=\"local.mage.dev\"\n")
    mi.add_setting("adminuser=\"admin\"\n")
    mi.add_setting("adminpass=\"admin2013\"\n")
    mi.add_setting("adminfname=\"MC\"\n")
    mi.add_setting("adminlname=\"Lovin\"\n")
    
    mi.add_setting("adminemail=\"test.user@wsu.edu\"\n")

    puts "the installer setting have been created"
end



