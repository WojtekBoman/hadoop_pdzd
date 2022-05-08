# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "gusztavvargadr/docker-community-ubuntu-server"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
    vb.cpus = "1"
  end

  config.vm.define "docker" do |docker|
     docker.vm.network "forwarded_port", guest: 20, host: 20
     docker.vm.network "forwarded_port", guest: 21, host: 21
     for i in 21100..21110
         docker.vm.network "forwarded_port", guest: i, host: i
     end
#     docker.vm.provision "shell", path: "bootstrap.sh"
  end
end
