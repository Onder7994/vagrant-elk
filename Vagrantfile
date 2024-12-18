Vagrant.configure("2") do |config|

    config.vm.box = "bento/ubuntu-22.04"
    config.vm.box_check_update = false
    config.vm.provision "shell", path: "init.sh"
    config.vm.hostname = "elk"
    config.vm.network "public_network", ip: "192.168.10.21", bridge: "wlp0s20f3"

    config.vm.synced_folder "./", "/vagrant"

    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 1
        vb.memory = 4096
        vb.gui = false
        vb.name = "elk"
        vb.check_guest_additions = false
    end
end