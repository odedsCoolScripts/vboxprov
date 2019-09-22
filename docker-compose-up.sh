#!/bin/bash
set -e

failure() {
  local lineno=$1
  local msg=$2
  echo "Script $0 Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR #Show line number and failed command of occures


echo password |sudo --stdin apt-get install git -y
git clone https://github.com/vegasbrianc/prometheus.git
docker swarm init
echo 'compsing containers:'
HOSTNAME=$(hostname) docker stack deploy -c ~/prometheus/docker-stack.yml prom > ~/prometheus/compose.log 2>&1
