#!/bin/bash


set +e

IMAGE=${1}
S=${2}
E=${3}

for i in `seq $S $E `; do ./run_node.sh $IMAGE node$i ;  done
