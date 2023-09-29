#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: dockerip CONTAINER"
  exit;
fi

docker inspect "$1" | jq -r '.[-1].NetworkSettings.Networks[].IPAddress'