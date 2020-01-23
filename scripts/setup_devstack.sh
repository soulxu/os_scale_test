#! /bin/bash
# The scripts is used to running devstack in container.

set +e

SETUP_TYPE=${1}
CONTROLLER_HOST=${2}
CONTROLLER_IP=${3}
BUILD_DEPS='git sudo libaio1 libaio-dev'
SCRIPT_DIR='/mnt'

cd ~

# Disable apparmor
#systemctl stop apparmor.service
#systemctl disable apparmor.service
#apt-get purge apparmor

apt-get update
apt-get -y install $BUILD_DEPS


apt-get -y install apparmor
cp $SCRIPT_DIR/usr.sbin.mysqld /etc/apparmor.d/
ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld


git clone https://github.com/openstack/devstack.git

# create stack user
~/devstack/tools/create-stack-user.sh

su - stack -c "git clone https://github.com/openstack/devstack.git"

if [ "$SETUP_TYPE" == "controller" ]; then
    cp $SCRIPT_DIR/controller_localrc /opt/stack/devstack/localrc
    echo "SERVICE_HOST="$(hostname) >> /opt/stack/devstack/localrc
elif [ "$SETUP_TYPE" == "compute" ]; then
    cp $SCRIPT_DIR/compute_localrc /opt/stack/devstack/localrc
    echo "SERVICE_HOST="$CONTROLLER_HOST >> /opt/stack/devstack/localrc
    echo "$CONTROLLER_IP $CONTROLLER_HOST" >> /etc/hosts
    cp $SCRIPT_DIR/setup_node.sh /opt/stack/
    cp $SCRIPT_DIR/setup_node.service /etc/systemd/system
    systemctl daemon-reload
    systemctl enable setup_node.service
else
    echo "Invalid setup type"
    exit 1
fi

su - stack -c "cd /opt/stack/devstack && git checkout origin/stable/pike" 

# Force the container env check always return True
su - stack -c "cd /opt/stack/devstack && git apply < $SCRIPT_DIR/force_container.patch"
su - stack -c "cd /opt/stack/devstack && git apply < $SCRIPT_DIR/start_mysql_before_config.patch"
su - stack -c "/opt/stack/devstack/stack.sh"

/bin/bash


