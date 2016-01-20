## Orchestrator

***The DevOps swiss-knife***

* Service deployments
* Scaling of services
* Automated service discovery
* Load balancing
* Zero configuration updates
* Configuration Management
* Continuous integration and deployment (in the pipeline)
* Rolling Deploys (in the pipeline)

It is an ensemble of services, all tightly integrated. You never have to care
about DevOps again!

A vagrant cluster has been provided as a proof-of-concept showing the
basic capabilities of the system.

**Under active development. Cheers!**

### Prerequisites

The project depends on the following packages:

* [`Ansible`](http://www.ansible.com) (for configuration management)
* [`Vagrant`](http://www.vagrantup.com) (for development VMs)

### Features

**NOTE**: Detailed documentation coming soon!
([issue](https://github.com/activatedgeek/bare-bones/issues/7))

**NOTE**: Almost all services have a GUI in place with health checks. `Please
point your system's DNS server to any of the nodes` to get rid of ports in your
URLs.

#### Service Deployments
All service deployments are handled via `Mesos` and `Marathon` with
`Docker` as the executor. `Chronos` has been provided to allow execution
of scheduled tasks. To access `Mesos`, point your browser to `mesos.service.consul`

#### Scaling of Services
`Marathon` provides an amazing API to execute jobs and scale as needed. It can
be accessed at `marathon.service.consul`.

#### Automated Service Discovery
Service discovery is all automated with zero-configuration thanks to
`Consul` and `Registrator`. All docker containers created in any node of the
`Mesos` cluster will have DNS resolution via `Consul` setup. Just request for
your dependent service!

#### Load balancing
Load balancing is automatically done via `Nginx` which builds on top of
service discovery provided by `Consul` and `Consul-Template`

#### Zero Configuration Updates
`Consul-Template` listens to any changes in the services and regenerates any
templates to render and appropriate commands to execute henceforth.

#### Configuration Management
All configuration management is done via `Ansible`, which provides agent-less
approach, therefore no pre-configuration is needed on any machines in the cluster
except for SSH access.

### Usage

For vagrant VM provisioning, the following `env` variables are available:
* `MESOS_MASTER_COUNT`: number of Mesos masters (default: `1`)
* `MESOS_SLAVE_COUNT`: number of Mesos slaves (default: `2`)
* `IP_CIDR_PREFIX`: IP addresses prefixes for machines (default: `192.168.80.0/24`)

All the above variables are optional and have been set to reasonable defaults
for a cluster on home machine. (starting to suck now!)

To setup any of the above variables, simply do a variable export as:
```
> export MESOS_MASTER_COUNT=3
> export MESOS_SLAVE_COUNT=6
> export IP_CIDR_PREFIX=10.0.1.0/24
```

To bootstrap the cluster and enable a `registrator` container on each slave node:
```
> vagrant up
> make registrator
```

To provision the cluster (should be already done once you do `vagrant up`):
```
> vagrant provision
```

#### Create A Sample service
```json
{
  "id": "test-outyet",
  "cpus": 0.5,
  "mem": 10.0,
  "instances": 5,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "outyet",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 0,
          "servicePort": 0,
          "protocol": "tcp"
        }
      ],
      "parameters": [
        { "key": "env", "value": "SERVICE_NAME=myoutyet" }
      ]
    }
  }
}
```

Submit this JSON job to Marathon as:
```
> curl -X POST marathon.service.consul/v2/apps \
  -d @outyet.json \
  -H "Content-type: application/json"
```

Once the job is started, you should be able to do:
```
> dig myoutyet.service.consul -t SRV
```
The output will show you the node and ports this service operates at.

### Contribution Guidelines

* Fork this repository
* Create your working branch and develop your feature
* Submit your pull request
* Watch out for [issues](https://github.com/activatedgeek/bare-bones/issues)

### Problems?
Raise an [issue](https://github.com/activatedgeek/bare-bones/issues/new)!
I promise I'll reply soon!
