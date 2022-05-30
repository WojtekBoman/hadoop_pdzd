# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "gusztavvargadr/docker-community-ubuntu-server"
    config.ssh.extra_args = ["-t", "cd /vagrant/hadoop-eco/docker-script; bash --login"]

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
    vb.cpus = "2"
  end

  config.vm.define "docker" do |docker|
     docker.vm.network "forwarded_port", guest: 20, host: 20
     docker.vm.network "forwarded_port", guest: 21, host: 21
     docker.vm.network "forwarded_port", guest: 3306, host: 3306
     docker.vm.network "forwarded_port", guest: 4040, host: 4040
     docker.vm.network "forwarded_port", guest: 8088, host: 8088
     docker.vm.network "forwarded_port", guest: 9000, host: 9000
     docker.vm.network "forwarded_port", guest: 9870, host: 9870
     docker.vm.network "forwarded_port", guest: 10000, host: 10000
     docker.vm.network "forwarded_port", guest: 10002, host: 10002
     docker.vm.network "forwarded_port", guest: 18080, host: 18080
     docker.vm.network "forwarded_port", guest: 50070, host: 50070
     for i in 21100..21110
         docker.vm.network "forwarded_port", guest: i, host: i
     end
#     docker.vm.provision "shell", path: "bootstrap.sh"
  end
end
