# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://docs.vagrantup.com

# when vagrant < 2.2.16, requires a patch to work with SMB shares
#
# patch discussion:
#   - https://github.com/hashicorp/vagrant/issues/12277#issuecomment-818999195
#   - https://github.com/Varying-Vagrant-Vagrants/VVV/issues/2446#issuecomment-826116104
#
# patch info:
#   file:
#      windows default install: C:\HashiCorp\Vagrant\embedded\gems\2.2.15\gems\vagrant-2.2.15\plugins\guests\linux\cap\mount_smb_shared_folder.rb
#   line: 23
#   original content: `mount_device = options[:plugin].capability(:mount_name, options)`
#   new content: `mount_device = options[:plugin].capability(:mount_name, name, options)`


Vagrant.configure("2") do |config|

  config.vagrant.plugins = ["vagrant-reload"]

  config.vm.box = "hashicorp/bionic64" # Ubuntu 18.04 LTS with support for VirtualBox and Hyper-V

  config.vm.network "forwarded_port", guest: 3000, host: 3000 # link guest port 3000 to host port 3000

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook1.yml"
  end

  config.vm.provision :reload

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook2.yml"
  end

  config.vm.provision :reload

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook3.yml"
  end

end
