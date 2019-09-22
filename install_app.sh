#!/bin/bash
set -e

# Configuration
SSH_PORT="$1"
MACHINE_USER_NAME="ubuntu" #can be changed to an argument, $2
#FILES=( "file1" "file2" "file3" )
FILES=( "docker-compose-up.sh" )

#Usage
if [[ -z "$SSH_PORT" ]] ; then
  printf "\nUsage for $0:\n  $0 <machine port number>"
  exit 0
fi

#Catch failures in line number
failure() {
  local lineno=$1
  local msg=$2
  echo "Script $0 Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR #Show line number and failed command of occures

#Copy files to machine
if ! [ -z "${FILES}" ]; then
  for i in "${FILES[@]}"; do
    coded_file=$(base64 "$i")
    ssh -p "$SSH_PORT" -i ~/.ssh/id_rsa_ubuntu_vm "$MACHINE_USER_NAME"@127.0.0.1 "echo $coded_file | base64 -d > ~/$i"
  done #I did not have SCP on the machines, so using base64 copy
fi

# commands to run:
COMMAND="chmod +x docker-compose-up.sh; bash docker-compose-up.sh"
# run docker compose or any other desired command from COMMAND
ssh -p "$SSH_PORT" -i ~/.ssh/id_rsa_ubuntu_vm "$MACHINE_USER_NAME"@127.0.0.1 "$COMMAND"
