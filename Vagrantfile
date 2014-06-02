# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/centos-6.5"

  config.vm.network "private_network", ip: "192.168.50.4"
  #config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "forwarded_port", guest: 5060, host: 5060, protocol: 'udp'

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    #   vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
  	#   vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ['modifyvm', :id, '--usb', 'on']
    # will be required for usb connections
    #vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'edimax7718un', '--vendorid', '0x7392']
  end

  config.vm.provision "shell", inline: "rpm --replacepkgs -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm"
  config.vm.provision "shell", inline: "rpm --replacepkgs -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
  config.vm.provision "shell", inline: "yum -y install puppet"
  config.vm.provision "shell", inline: "puppet module install puppetlabs-mysql"
  config.vm.provision "shell", inline: "puppet module install puppetlabs-apache"
  config.vm.provision "shell", inline: "puppet module install example42-php"
  config.vm.provision "shell", inline: "puppet module install example42-perl"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
    puppet.options = "--verbose --debug"
  end

end
