#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

KIBANA_UI_PASS="elastic"
KIBANA_ELK_PASS="kibana_system"
ELASTIC_VERSION="8.17.0"
KIBANA_VERSION="8.17.0"
LOGSTASH_VERSION="1:8.17.0-1"

function requirements_install() {
    sudo apt-get update -y
    sudo apt-get install -y unzip git apt-transport-https curl gnupg openjdk-17-jre
    java -version
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
    sudo apt-get update
}

function install_elastic() {
    sudo apt-get install -y elasticsearch=$ELASTIC_VERSION
    if [ -f /vagrant/configs/elasticsearch/elasticsearch.yml ]; then
        sudo cp /vagrant/configs/elasticsearch/elasticsearch.yml /etc/elasticsearch/
    fi;
    sudo systemctl daemon-reload
    sudo systemctl enable elasticsearch
    sudo systemctl start elasticsearch
    echo -e "$KIBANA_ELK_PASS\n$KIBANA_ELK_PASS" | /usr/share/elasticsearch/bin/elasticsearch-reset-password -u kibana_system -i --batch
}

function install_logstash() {
    sudo apt-get install -y logstash=$LOGSTASH_VERSION
    if [ -d /vagrant/configs/logstash/ ]; then
      sudo cp -R /vagrant/configs/logstash/* /etc/logstash/conf.d/
    fi;
    sudo systemctl enable logstash
    sudo systemctl start logstash
}

function install_kibana() {
    sudo apt-get install -y kibana=$KIBANA_VERSION
    if [ -f /vagrant/configs/kibana/kibana.yml ]; then
      sudo cp /vagrant/configs/kibana/kibana.yml /etc/kibana/
    fi;
    sudo sed -i "s/^elasticsearch\.password:.*/elasticsearch.password: \"$KIBANA_ELK_PASS\"/" /etc/kibana/kibana.yml
    usermod -aG elasticsearch kibana
    sudo systemctl daemon-reload
    sudo systemctl enable kibana
    sudo systemctl start kibana
}

function install_nginx() {
    sudo apt-get install -y nginx
    sudo mkdir -p /etc/nginx/ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/kibana.key \
      -out /etc/nginx/ssl/kibana.crt \
      -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=kibana.lan"

    if [ -f /vagrant/configs/nginx/kibana.conf ];then
        sudo cp /vagrant/configs/nginx/kibana.conf /etc/nginx/conf.d/kibana.conf
    fi;
    if [ -f /vagrant/configs/nginx/nginx.conf ];then
        sudo cp /vagrant/configs/nginx/nginx.conf /etc/nginx/nginx.conf
    fi;
    sudo systemctl daemon-reload
    sudo systemctl enable nginx
    sudo systemctl restart nginx

}

function set_elk_pass() {
    echo -e "$KIBANA_UI_PASS\n$KIBANA_UI_PASS" | /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -i --batch
}

requirements_install
install_elastic
install_logstash
install_kibana
install_nginx
set_elk_pass
echo -e "Kibana admin user: elastic\n"
echo -e "Kibana admin password: $KIBANA_UI_PASS\n"