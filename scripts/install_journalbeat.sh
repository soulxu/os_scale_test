#! /bin/bash


set +e

CONTROLLER_HOST=oscontroller

curl -L -O https://artifacts.elastic.co/downloads/beats/journalbeat/journalbeat-7.5.2-amd64.deb
sudo dpkg -i journalbeat-7.5.2-amd64.deb

systemctl daemon-reload
systemctl enable journalbeat.service


apt-get install jq
pip install yq

units=`systemctl list-units devstack@*|cut -d ' ' -f 1`
unit_list=''

for u in $units; do
    if [ -f "/etc/systemd/system/"$u ]; then
        echo $u
        if [ -z "$unit_list" ]; then
            unit_list="\"systemd.unit=$u\""
        else
            unit_list=$unit_list", \"systemd.unit=$u\""
        fi
    fi
done

cp /etc/journalbeat/journalbeat.yml /etc/journalbeat/journalbeat.yml.sa
x=".\"journalbeat.inputs\"[0].include_matches = ["$unit_list"]"
cat /etc/journalbeat/journalbeat.yml |yq -y "$x" > /etc/journalbeat/journalbeat.yml.new
cp /etc/journalbeat/journalbeat.yml.new /etc/journalbeat/journalbeat.yml

# assume logstash on localhost
cat /etc/journalbeat/journalbeat.yml |yq -y ".\"output.logstash\" = {\"hosts\": [\"$CONTROLLER_HOST:5044\"]}" > /etc/journalbeat/journalbeat.yml.new

cp /etc/journalbeat/journalbeat.yml.new /etc/journalbeat/journalbeat.yml
