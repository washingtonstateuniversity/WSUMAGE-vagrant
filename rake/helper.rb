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


    def create_file(path)
        require 'fileutils'
        dir = File.dirname(path)
        
        if !File.exists?(dir)
            Dir.mkdir(File.join(Dir.pwd, path), 0700) #=> 0
            puts "ceated file #{path}\n"
        else
            puts "existing file #{path}\n"
        end
    end
    
    def download(from,to)
        ['net/http','uri'].each_with_index {|i| require i}
        
        counter = 0

        url_base = from.split('/')[2]
        url_path = '/'+from.split('/')[3..-1].join('/')
             
        puts "starting download for #{url_path}\n"
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
              end
            end
          ensure
            file.close
          end
        end
        puts "completed download for #{url_path}\n"
    end

end