#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

TOOLS_DIR=$SCRIPT_DIR/tools

for fullfile in $TOOLS_DIR/*.sh; do
  filename=$(basename -- "$fullfile")
  command="${filename%.*}"
  echo "... $command"
  sudo ln -s -f "$fullfile" "/usr/bin/$command"
done

COMPLETIONS_DIR=$SCRIPT_DIR/completions

for fullfile in $COMPLETIONS_DIR/*.sh; do
  filename=$(basename -- "$fullfile")
  sed -i "/$filename/d" ~/.bashrc
  echo "source $fullfile" >> ~/.bashrc
done

source ~/.bashrc
