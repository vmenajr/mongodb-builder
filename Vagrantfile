# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Common settings
  #config.ssh.forward_x11 = true

  # Provider settings
  config.vm.provider "parallels" do |v|
    v.update_guest_tools=true
    v.memory="4096"
    v.cpus=2
  end


  # Dot files
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  config.vm.provision "file", source: "~/.git_global_ignores", destination: "~"
  config.vm.provision "file", source: "~/.bash_aliases", destination: ".bash_aliases"
  config.vm.provision "file", source: "~/.vimrc", destination: ".vimrc"
  config.vm.provision "file", source: "~/.vim", destination: "~"
  config.vm.provision "file", source: "~/.ssh", destination: "~"

  # Machines
  config.vm.define "trusty", autostart:false do |c|
    c.vm.box = "bento/ubuntu-14.04"
    c.vm.provision "shell", inline: <<-SHELL
      echo "Install dependencies"
      apt-get -y update
      apt-get -y upgrade
      apt-get -y install build-essential tree vim git git-sh htop scons
    SHELL
    c.vm.provision "shell", name: "Install-g++-5", path: "install-g++-5.sh"
    c.vm.provision "shell", name: "Clone MongoDB", path: "clone-mongodb.sh"
    c.vm.provision "shell", name: "Personlize", path: "personalize.sh"
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
    c.vm.provision "shell", name: "Clone MongoDB", path: "clone-mongodb.sh"
    c.vm.provision "shell", name: "Personlize", path: "personalize.sh"
    c.vm.provision :reload
  end
end

