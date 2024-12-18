# vagrant-elk

Simple ELK stack in one node with nginx like reverse proxy for kibana.

Req DNS record A -> IP address ELK vm. In this case dns record is `kibana.lan`
DNS server should be install not from here.

By default nginx is enabled, if you don't want to use it, just commend or delete `install_nginx` function in `init.sh`.

# Pre configure
Change some parameters like ip or bridge interface in Vagrantfile
`config.vm.network "public_network", ip: "192.168.10.21", bridge: "wlp0s20f3"`

# Install
```bash
vagrant up
```