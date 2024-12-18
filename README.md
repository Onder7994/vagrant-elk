# vagrant-elk

Simple ELK stack in one node with nginx like reverse proxy for kibana.

Req DNS record A -> IP address ELK vm. In this case dns record is `kibana.lan`
DNS server should be install not from here.

By default nginx is enabled, if you don't want to use it, just commend or delete `install_nginx` function in `init.sh`.

# Install
```bash
vagrant up
```