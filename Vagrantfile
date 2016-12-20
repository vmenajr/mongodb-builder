# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Required plugins
  [
    "vagrant-reload",
  ]
  .each do |pluginName|
    unless Vagrant.has_plugin?(pluginName)
      raise "Missing required plugin: #{pluginName}"
    end
  end

  # Common settings
  #config.ssh.forward_x11 = true

  # Provider settings
  config.vm.provider "virtualbox" do |v|
    #v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.memory=2048
    v.cpus=2
    # VirtualBox auto-guest addition rebuild
    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
  end
  config.vm.provider "parallels" do |v|
    v.update_guest_tools=true
    v.memory=2048
    v.cpus=2
  end


  # Hosts
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = false
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end


  # Dot files
  [
    ".gitconfig",
    ".git_global_ignores",
    ".bash_aliases",
    ".vimrc",
    ".vim",
    ".ssh",
  ]
  .each do |dotfile|
    name="~/#{dotfile}"
    if File.exists?(File.expand_path(name))
      config.vm.provision "file", source: "#{name}", destination: "#{name}"
    end
  end


  # Machines
  config.vm.define "trusty", autostart:false do |c|
    c.vm.box = "bento/ubuntu-14.04"
    c.vm.provision "shell", inline: <<-SHELL
      echo "Install dependencies"
      apt-get -y update
      apt-get -y upgrade
      apt-get -y install build-essential tree vim git git-sh htop scons
    SHELL
    c.vm.provision "shell", name: "Install-g++-5", path: "provision/ubuntu/install-g++-5.sh"
    c.vm.provision "shell", name: "Clone MongoDB", path: "provision/clone-mongodb.sh"
    c.vm.provision "shell", name: "Personlize", path: "provision/personalize.sh"
    c.vm.provision :reload
  end

  config.vm.define "centos72", autostart:false do |c|
    c.vm.box = "bento/centos-7.2"
    c.vm.provision "shell", inline: <<-SHELL
      yum -y install epel-release
      yum -y update
      yum -y groupinstall "Development Tools"
      yum -y install vim tree git git-sh scons
    SHELL
    c.vm.provision "shell", name: "Download GCC 5.4", path: "provision/centos/download-gcc.sh", args: ["5.4.0"]
    c.vm.provision "shell", name: "Clone MongoDB", path: "provision/clone-mongodb.sh"
    c.vm.provision "shell", name: "Personlize", path: "provision/personalize.sh"
    c.vm.provision :reload
  end
end

