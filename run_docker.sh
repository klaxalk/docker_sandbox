#!/bin/bash

## | -------------------------- paths ------------------------- |

SCRIPT_PATH=`dirname "$0"`
SCRIPT_PATH=`( cd "$SCRIPT_PATH" && pwd )`

## | ---------------------- configuration --------------------- |

DEBUG=false

CONTAINER_DATA_FOLDER=/local/data
CONTAINER_WORK_FOLDER=/local/work

HOST_DATA_FOLDER=$SCRIPT_PATH/data
HOST_WORK_FOLDER=$SCRIPT_PATH/work

mkdir -p $HOST_WORK_FOLDER

DOCKER_IMAGE=klaxalk/sandbox:test

ENABLE_DISPLAY=false

PASS_NETWORK=true

ENTRY_POINT=entry_point.sh

ENV_VARS=(
  'DISPLAY' "$DISPLAY"
)

MOUNTS=(
  "$HOST_DATA_FOLDER" "$CONTAINER_DATA_FOLDER"
  "$HOST_WORK_FOLDER" "$CONTAINER_WORK_FOLDER"
  '/tmp/.X11-unix' '/tmp/.X11-unix'
)

## | --------------------- user config end -------------------- |

## | --------------- parse environment variables -------------- |

for ((i=0; i < ${#ENV_VARS[*]}; i++));
do
  ((i%2==0)) && env_var_name[$i/2]="${ENV_VARS[$i]}"
  ((i%2==1)) && env_var_value[$i/2]="${ENV_VARS[$i]}"
done

ENV_ARG=""

for ((i=0; i < ${#env_var_name[*]}; i++));
do

  ENV_ARG="$ENV_ARG -e ${env_var_name[$i]}=${env_var_value[$i]}"

done

## | ---------------- parse mounting locations ---------------- |

for ((i=0; i < ${#MOUNTS[*]}; i++));
do
  ((i%2==0)) && mount_host[$i/2]="${MOUNTS[$i]}"
  ((i%2==1)) && mount_container[$i/2]="${MOUNTS[$i]}"
done

MOUNT_ARG=""

for ((i=0; i < ${#mount_host[*]}; i++));
do

  MOUNT_ARG="$MOUNT_ARG -v ${mount_host[$i]}:${mount_container[$i]}"

done

## | ------------------------ net param ----------------------- |

NET_ARG=""
if ! $PASS_NETWORK; then
  NET_ARG=" --net=none"
fi

## | -------------------------- debug ------------------------- |

if $DEBUG; then
  EXEC_CMD="echo"
else
  EXEC_CMD="eval"
fi

## | ----------------------- run docker ----------------------- |

[ $ENABLE_DISPLAY ] && xhost +

$EXEC_CMD docker run -t \
  --rm \
  $NET_ARG \
  --privileged \
  $MOUNT_ARG \
  -u "$(id -u):$(id -g)" \
  $ENV_ARG \
  -w $CONTAINER_DATA_FOLDER \
  $DOCKER_IMAGE $CONTAINER_DATA_FOLDER/$ENTRY_POINT $CONTAINER_WORK_FOLDER

[ $ENABLE_DISPLAY ] && xhost -
