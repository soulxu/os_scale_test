curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.0-amd64.deb
sudo dpkg -i filebeat-7.6.0-amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
