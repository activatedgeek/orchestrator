## Bare-Bones Mesos

This is a bare bones `Mesos` cluster which sets up a basic
requirements on top of `Ubuntu 14.04.3 LTS`. This project aims
to be a highly opinionated list of practices for cluster
management via `Mesos` (and other frameworks on top) which can
get you setup for easy and reproducible development and production
environments.

**NOTE**: Under active development. Cheers!

### Prerequisites

The project depends on the following packages:

* [`Ansible`](http://www.ansible.com) (for configuration management)
* [`Vagrant`](http://www.vagrantup.com) (for development VMs)

### Features

This project sets up the following cluster and frameworks:
* [`Mesos`](http://mesos.apache.org)
  * GUI accessible at `IP_ADDRESS_OF_ANY_MASTER:5050`
* [`Docker`](https://www.docker.com) support for `Mesos`
* [`Marathon`](https://mesosphere.github.io/marathon/)
  * GUI accessible at `IP_ADDRESS_OF_ANY_MASTER:8080`
* [`Chronos`](http://mesos.github.io/chronos/)
	* GUI accessible at `IP_ADDRESS_OF_ANY_MASTER:4400`

##### Future releases

Here is a list of features I am planning to support soon:
* Configurable `Jenkins` support for continuous delivery
* `Weave` support for automated service discovery and load balancing
* A configurable edge `Nginx` reverse proxy to route to internal
services transparently

More suggestions and industry practices are welcome!

### Setup

While starting the cluster, the following `env` variables are available to be configured:

* `MESOS_MASTER_COUNT`: number of Mesos masters to boot (default: `1`)
* `MESOS_SLAVE_COUNT`: number of Mesos slaves to boot (default: `2`)
* `IP_CIDR_PREFIX`: IP addresses to assign to machines (default: `192.168.80.0/24`)
* `ANSIBLE_PLAYBOOK`: ansible playbook to be used during provisioning (default: `mesos.yml`)

All the above variables are optional and have been set to reasonable defaults for a personal development cluster.

To setup any of the above variables, simply do a variable export as:
```
> export MESOS_MASTER_COUNT=3
> export MESOS_SLAVE_COUNT=6
> export IP_CIDR_PREFIX=10.0.1.0/24
> export ANSIBLE_PLAYBOOK=mesos.yml
```

### Bootstrap

To start the cluster, run:
```
> vagrant up
```

To disable provisioning (and use your own choice of provisioner later):
```
> vagrant up --no-provision
```

To provision after the machines have been created:
```
> vagrant provision
```

To provision only the master nodes:
```
> ANSIBLE_PLAYBOOK=mesos-master.yml vagrant provision
```

To provision only the slave nodes:
```
> ANSIBLE_PLAYBOOK=mesos-slave.yml vagrant provision
```

### Contribution Guidelines ###

* Fork this repository
* Create your working branch and develop your feature
* Submit your pull request
* Watch out for issues [here](https://github.com/activatedgeek/ansible-vagrant-mesos/issues)

### Problems? ###
Raise an issue [here](https://github.com/activatedgeek/ansible-vagrant-mesos/issues/new) ! I promise I'll reply soon!
