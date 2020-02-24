IMAGE=${1}
HOSTNAME=${2}

NETWORK=bridge
SCRIPT_DIR="$(pwd)/scripts"
docker run -d -v "$SCRIPT_DIR:/mnt" -v /lib/modules/4.4.0-116-generic:/lib/modules/4.4.0-116-generic --cap-add=NET_ADMIN --privileged --network $NETWORK --hostname $HOSTNAME --name $HOSTNAME $IMAGE /sbin/init
