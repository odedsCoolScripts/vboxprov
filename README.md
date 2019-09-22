# Virtual Box Provisioning and Install
Provisioning VirtualBox with given .ova files and send ssh commands

## Description

In this project we're also demonstrate how to run docker-compose to the created machines with Grafite, Grafana and Promitues

## Getting Started

### Dependencies

* VirtualBox host installed on a local machine (Can be modified to remote host)
* Internet access from VBox host to Github, AWS S3 (for .ovh file), Docker hub and ubuntu apt-get- ubuntu repo.  

### Installing

* Clone the project to your working directory on local machine
* Install the matching ssh key for the machine .ovh file on your the VirtualBox host's ~/.ssh folder. The key will be provided  by private request).

### Getting started

* This project consisted of 3 scripts chain reaction, started by `VBoxStartFromImage.sh`.
* The first script- `VBoxStartFromImage.sh` should Provision machines from argument .ova file (exported VBox machine image), local or by http link. The script is iteratable.
* The second script- `install_app.sh` is called at the end of `VBoxStartFromImage.sh` and should copy files and install scripts on the created VM.
* The third and last script- `docker-compose-up.sh` is copied to the VM and in our case will install docker stack with predefined Grafana, Promethues and NodeExporter, to observe graphs for CPU and Memory usage on the machine  

#### FIrst script- VBoxStartFromImage.sh
will receive the the arguments:
VM name, path to .ovh file (either local or http), unique port to ssh the VM to configure in Port Forwarding (default: 2222), VM machine's Username (ubuntu in our case).
Example:
```
./VBoxStartFromImage.sh ubuntu_14 https://virtual-box-oded.s3.eu-central-1.amazonaws.com/base_ubuntu_14_with_docker_compose.ova 2222 ubuntu
```
If the path to .ovh file is http, we'll download it by curl, unless it's already downloaded.
If the path to .ovh is local, it will be copied to the working directory, unless it's already there.  

Iterating the script:
```
ovh_file="https://virtual-box-oded.s3.eu-central-1.amazonaws.com/base_ubuntu_14_with_docker_compose.ova"
./VBoxStartFromImage.sh ubuntu_14 "$ovh_file" 2222 ubuntu
./VBoxStartFromImage.sh ubuntu_14_1 "$ovh_file" 2223 ubuntu
./VBoxStartFromImage.sh ubuntu_14_2 "$ovh_file" 2224 ubuntu
```
Note: This script should not be modified unless some there are crucial requirement to the change the VMs settings before it starts. See lines: 32-36 (port fwd and host IP).

#### Second script- install_app.sh
This script receives the VM's ssh port and its user name when it's called by VBoxStartFromImage.sh.
As the script's nature, probability of modifying it is higher. In this case, it's just copying on script file (`docker-compose-up.sh`) to the VM and runs it inside the VM.
The files that should be copied can be added to the array in line 7-8:
```
#FILES=( "file1" "file2" "file3" ) # - Example of files array
FILES=( "docker-compose-up.sh" )
```
#### Third script- docker-compose-up.sh
This script made especially for our stack to install and have my personal preferences.
It will install GIT on the VM, git clone of a project that runs the Docker stack, deploy the Docker stack:
```
echo password |sudo --stdin apt-get install git -y
git clone https://github.com/vegasbrianc/prometheus.git
docker swarm init
echo 'composing containers:'
HOSTNAME=$(hostname) docker stack deploy -c ~/prometheus/docker-stack.yml prom > ~/prometheus/compose.log 2>&1

```
Grafana url will be (local VirtualBox host): http://127.0.0.1:10222 .Port consisted of number 10 and last 3 digits of the provided port for ssh.
Default user: admin. password: foobar

## Limitations

* port argument in the first script must be 4 digits starting from the first machine port number.
* Graphite data source and container is not provided in this project. we'll add it in next version.
* The current .ovh file image provided here doesn't authenticate with the ssh key file installed and configured in /etc/ssh/sshd_config and in authorized_keys. Need to investigate that, will appear in next version.


## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [prometheus and docker compose](https://github.com/vegasbrianc/prometheus#installation--configuration)
