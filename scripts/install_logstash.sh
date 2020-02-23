#! /bin/bash

set -e

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get install openjdk-8-jdk
sudo apt-get update && sudo apt-get install logstash



cat > /etc/logstash/conf.d/jb.conf << "EOF"
input {
    beats {
        port => "5044"
        host => "0.0.0.0"
    }
}
output {
    elasticsearch {
        hosts => ["localhost:9200"]
    }
}
EOF
