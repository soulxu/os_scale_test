#! /bin/bash

set +e

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && sudo apt-get install elasticsearch


systemctl daemon-reload
systemctl enable elasticsearch.service

# Expose the elasticsearch public need more configuration
# https://discuss.elastic.co/t/problems-with-access-to-elasticsearch-form-outside-machine/172450
#echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
