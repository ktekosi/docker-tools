#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: dockerbash CONTAINER"
  exit;
fi

docker exec -it "$1" /bin/bash