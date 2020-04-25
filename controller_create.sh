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
NETWORK=br0
SCRIPT_DIR="$(pwd)/scripts"


#docker run -d -v "$SCRIPT_DIR:/mnt" -v /lib/modules/4.4.0-116-generic:/lib/modules/4.4.0-116-generic --privileged --device /dev/kvm --network $NETWORK --name base $BASE_IMAGE /sbin/init
# --cap-add=ALL
BASE_CONTAINER_ID=`docker run -d -v "$SCRIPT_DIR:/mnt" --cap-add=NET_ADMIN --privileged --network $NETWORK --hostname $HOSTNAME $BASE_IMAGE /sbin/init`
docker exec -it $BASE_CONTAINER_ID /mnt/setup_devstack.sh controller
docker kill $BASE_CONTAINER_ID
docker commit $BASE_CONTAINER_ID $IMAGE_NAME
