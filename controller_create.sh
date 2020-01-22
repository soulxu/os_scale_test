#! /bin/bash
# The script is used to create a controller image
set +e
# This is used for Pike release

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [hostname] [image_name]"
    exit 1
fi

HOSTNAME=${1}
IMAGE_NAME=${2}

BASE_IMAGE=ubuntu:16.04
NETWORK=bridge
SCRIPT_DIR="$(pwd)/scripts"


ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld

#docker run -d -v "$SCRIPT_DIR:/mnt" -v /lib/modules/4.4.0-116-generic:/lib/modules/4.4.0-116-generic --privileged --device /dev/kvm --network $NETWORK --name base $BASE_IMAGE /sbin/init
# --cap-add=ALL
docker run -d -v "$SCRIPT_DIR:/mnt" --cap-add=NET_ADMIN --privileged --network $NETWORK --hostname $HOSTNAME --name base $BASE_IMAGE /sbin/init
docker exec -it base /mnt/setup_devstack.sh
docker commit base $IMAGE_NAME
