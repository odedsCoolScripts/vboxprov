#!/bin/bash
set -e
VM_NAME="$1"
PATH_TO_OVA="$2"
SSH_PORT="$3"
MACHINE_USER_NAME="$4"
CURRENT_DIR=$(pwd)

if [[ -z "$VM_NAME" ]] | [[ -z "$PATH_TO_OVA" ]] | [[ -z "$SSH_PORT" ]] | [[ -z "$MACHINE_USER_NAME" ]] ; then
  printf "\nUsage for $0:\n  $0 <Desired VM name> <OVA path for VM's OS> <port (2222)> <machine_user_name (ubuntu)>"
  exit 0
fi

failure() {
  local lineno=$1
  local msg=$2
  echo "Script $0 Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR #Show line number and failed command of occures

BASE_IMAGE=$(echo "$PATH_TO_OVA"| grep -o -E '[0-9A-Za-z\.\-\_]+'.ova | head -1)
#Download base ubuntu image if needed
if ! [ -f "$CURRENT_DIR/$BASE_IMAGE" ] ; then
  if (echo "$PATH_TO_OVA"| grep -q -i http ); then
    curl "$PATH_TO_OVA" --output "$CURRENT_DIR"/"$BASE_IMAGE"
  else
    cp "$PATH_TO_OVA" "$CURRENT_DIR"/"$BASE_IMAGE"
  fi
fi
mkdir "$CURRENT_DIR"/"$VM_NAME"
# Install the machine image:
VBoxManage import "$CURRENT_DIR"/"$BASE_IMAGE" \
--vsys 0 --vmname "$VM_NAME" \
--vsys 0 --settingsfile "$CURRENT_DIR"/"$VM_NAME"/"$VM_NAME".vbox \
--vsys 0 --basefolder "$CURRENT_DIR"/"$VM_NAME" \
--vsys 0 --unit 14 --disk "$CURRENT_DIR"/"$VM_NAME"/"$VM_NAME".vmdk

#Modify port forwarding:
if ! [ "$SSH_PORT" == "2222" ]; then #skip the default rule for the first machine
  VBoxManage modifyvm "$VM_NAME" --natpf1 "SSH,tcp,127.0.0.1,$SSH_PORT,10.0.2.15,22"
fi
#open port fwd for grafana
http_port=$(echo 10$(echo "$SSH_PORT" | cut -c 2-4))
VBoxManage modifyvm "$VM_NAME" --natpf1 "SSH,tcp,127.0.0.1,$http_port,10.0.2.15,3000"

#start VM:
VBoxManage startvm "$VM_NAME" --type headless

#Install applications:
"$CURRENT_DIR"/install_app.sh "$SSH_PORT" "$MACHINE_USER_NAME"
