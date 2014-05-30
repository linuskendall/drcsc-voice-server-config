# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/centos-6.5"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    #   vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
  	#   vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ['modifyvm', :id, '--usb', 'on']
    # will be required for usb connections
    #vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'edimax7718un', '--vendorid', '0x7392']
  end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file chef/centos-6.5.pp in the manifests_path directory.
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "default.pp"
  end

end
