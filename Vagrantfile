# -*- mode: ruby -*-
# vi: set ft=ruby :


# Specify Vagrant version, Vagrant API version, and Vagrant clone location
Vagrant.require_version '>= 1.6.0'
VAGRANTFILE_API_VERSION = '2'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

# Require 'yaml', 'fileutils', and 'erb' modules
require 'yaml'
require 'fileutils'
require 'erb'


# Read YAML file with VM details (box, CPU, RAM, IP addresses)
# Be sure to edit servers.yml to provide correct IP addresses
servers = YAML.load_file(File.join(File.dirname(__FILE__), 'servers.yml'))
#
# generate script to create hosts entries for cluster members
#
hFile=File.new("scripts/setHosts.sh","wb")
hFile.puts "cat <<EOF>>/etc/hosts"
servers.each do |hentry|
	hFile.puts "#{hentry['priv_ip']}  #{hentry['name']}" 
end
hFile.puts "EOF"
hFile.close
#
# End hosts scripts generation
#
# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Always use Vagrant's default insecure key
  config.ssh.insert_key = false
  # Iterate through entries in YAML file to create VMs
  servers.each do |server|
    config.vm.define server['name'] do |srv|
    	SERVER_NAME=server['name']
      # Don't check for box updates
      srv.vm.box_check_update = false
      srv.vm.hostname = server['name']
      srv.vm.box = server['box']
      # Assign an additional static private network
      srv.vm.network 'private_network', ip: server['priv_ip']
      # Enable default synced folder
      srv.vm.synced_folder '.', '/vagrant'
      srv.vm.provision 'shell', path: 'scripts/setHosts.sh'
      # Run Docker installation
      srv.vm.provision 'shell', path: 'scripts/installDocker.sh'
      srv.vm.provision 'shell', path: 'scripts/configSwarm.sh'
      srv.vm.provision 'shell', path: 'scripts/installGluster.sh'      
      # Configure VMs with RAM and CPUs per settings in servers.yml (VirtualBox)
      srv.vm.provider :virtualbox do |vb|
        vb.memory = server['ram']
        vb.cpus = server['vcpu']
      end # srv.vm.provider virtualbox
    end # config.vm.define
  end # servers.each
end # Vagrant.configure
