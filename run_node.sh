IMAGE=${1}
HOSTNAME=${2}

NETWORK=bridge
SCRIPT_DIR="$(pwd)/scripts"
docker run -d -v "$SCRIPT_DIR:/mnt" --cap-add=NET_ADMIN --privileged --network $NETWORK --hostname $HOSTNAME --name $HOSTNAME -e CONTROLLER_IP=$SERVICE_IP $IMAGE /sbin/init
