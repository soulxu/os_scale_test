#!/bin/bash

IP=`ip addr show dev eth0|grep inet|cut -d ' ' -f6|cut -d '/' -f1`
echo "node ip: "$IP


source /opt/stack/devstack/inc/ini-config

iniset -sudo /etc/neutron/plugins/ml2/ml2_conf.ini "ovs" "local_ip" $IP

#echo "$CONTROLLER_IP $CONTROLLER_HOST" >> /etc/hosts

cat /etc/hosts |eval sed '/$CONTROLLER_HOST/d' > /etc/hosts.new
cp /etc/hosts.new /etc/hosts
echo "$CONTROLLER_IP $CONTROLLER_HOST" >> /etc/hosts

cat /etc/hosts |eval sed '/$LOG_HOST/d' > /etc/hosts.new
cp /etc/hosts.new /etc/hosts
echo "$LOG_IP $LOG_HOST" >> /etc/hosts
