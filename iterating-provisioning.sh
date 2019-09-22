#!/bin/bash
set -e

failure() {
  local lineno=$1
  local msg=$2
  echo "Script $0 Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR #Show line number and failed command of occures


./VBoxStartFromImage.sh ubuntu_14 https://virtual-box-oded.s3.eu-central-1.amazonaws.com/base_ubuntu_14_with_docker_compose.ova 2222 ubuntu
./VBoxStartFromImage.sh ubuntu_14_1 https://virtual-box-oded.s3.eu-central-1.amazonaws.com/base_ubuntu_14_with_docker_compose.ova 2223 ubuntu
./VBoxStartFromImage.sh ubuntu_14_2 https://virtual-box-oded.s3.eu-central-1.amazonaws.com/base_ubuntu_14_with_docker_compose.ova 2224 ubuntu
