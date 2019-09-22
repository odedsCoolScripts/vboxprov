# vboxprov
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

#### FIrst script- `VBoxStartFromImage.sh`
will receive 
```
code blocks for commands
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)
