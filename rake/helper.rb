#NOTA: this is actually rake/helper.rb but gists can't named files as directories

require 'vagrant'

class VM
  def initialize(opts=nil)
    opts ||= {ui_class: Vagrant::UI::Colored}
    @env = Vagrant::Environment.new(opts)
    @vm = @env.primary_vm
  end

  def project_path
    @vm.config.vm.shared_folders['v-project'][:guestpath]
  end

  def check_if_alive
    raise "Must run `vagrant up`" if !@vm.created?
    raise "Must be running!" if @vm.state != :running
  end

  def cli(command=nil)
    @env.cli(command) if command
  end

  def sudo(command=nil)
    check_if_alive
    @vm.channel.sudo(command) if command
  end

  def execute(command=nil, cwd=nil)
    check_if_alive
    cwd ||= project_path
    command = "cd #{cwd}; #{command}"

    # Some code borrowed from Vagrant::Command::SSH.ssh_execute 
    exit_status = 0
    
    exit_status = @vm.channel.execute(command, :error_check => false) do |type, data|
      channel = type == :stdout ? :out : :error
      case type
      when :stdout
        color = :green
      when :stderr
        color = :red
      else
        color = :clear
      end

      # Print the SSH output as it comes in, but don't prefix it and don't
      # force a new line so that the output is properly preserved
      @vm.ui.info(data.to_s,
                  :prefix   => false,
                  :new_line => false,
                  :channel  => channel,
                  :color    => color)
    end

    # Exit with the exit status we got from executing the command
    exit exit_status
  end
end

