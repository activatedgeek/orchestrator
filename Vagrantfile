# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'ipaddr'

def log (level, msg)
  puts "[#{level}] #{msg}"
end

##
# Available Options (use the same options when using "vagrant destroy")
#
# MESOS_MASTER_COUNT=
# MESOS_SLAVE_COUNT=
# IP_CIDR_PREFIX=
#
$MESOS_MASTER_COUNT = (ENV['MESOS_MASTER_COUNT'] || 1).to_i
log("vars", "MESOS_MASTER_COUNT=#{$MESOS_MASTER_COUNT}")

$MESOS_SLAVE_COUNT = (ENV['MESOS_SLAVE_COUNT'] || 2).to_i
log("vars", "MESOS_SLAVE_COUNT=#{$MESOS_SLAVE_COUNT}")

$IP_CIDR_PREFIX = ENV['IP_CIDR_PREFIX'] || "192.168.80.0/24"
log("vars", "IP_CIDR_PREFIX='#{$IP_CIDR_PREFIX}'")

$IP = IPAddr.new($IP_CIDR_PREFIX)
# skip first address
$IP = $IP.succ

# groups for ansible
ansibleGroups = {
  "mesos-master" => [],
  "mesos-slave" => [],
  "consul-server" => [],
  "consul-client" => [],
  "edge" => []
}

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  (1..$MESOS_MASTER_COUNT).each do |m_id|

    config.vm.define "mesos-master-#{m_id}" do |master|
      master.vm.hostname = "mesos-master-#{m_id}"
      ansibleGroups["mesos-master"].insert(-1, master.vm.hostname)
      ansibleGroups["consul-server"].insert(-1, master.vm.hostname)

      $IP = $IP.succ
      master.vm.network "private_network", ip: $IP.to_s

      master.vm.provider "virtualbox" do |vb|
        vb.name = master.vm.hostname
        vb.gui = false
        vb.cpus = 2
        vb.memory = "1536"
      end
    end
  end

  (1..$MESOS_SLAVE_COUNT).each do |s_id|
    config.vm.define "mesos-slave-#{s_id}" do |slave|
      slave.vm.hostname = "mesos-slave-#{s_id}"
      ansibleGroups["mesos-slave"].insert(-1, slave.vm.hostname)
      ansibleGroups["consul-client"].insert(-1, slave.vm.hostname)

      $IP = $IP.succ
      slave.vm.network "private_network", ip: $IP.to_s

      slave.vm.provider "virtualbox" do |vb|
        vb.name = slave.vm.hostname
        vb.gui = false
        vb.cpus = 2
        vb.memory = "1536"
      end
    end
  end

  config.vm.define "edge-1" do |edge|
    edge.vm.hostname = "edge-1"
    ansibleGroups["consul-client"].insert(-1, edge.vm.hostname)
    ansibleGroups["edge"].insert(-1, edge.vm.hostname)

    $IP = $IP.succ
    edge.vm.network "private_network", ip: $IP.to_s

    edge.vm.provider "virtualbox" do |vb|
      vb.name = edge.vm.hostname
      vb.gui = false
      vb.memory = "512"
    end

    ##
    # @NOTE a workaround to attach provisioner
    # to last node
    #
    edge.vm.provision :ansible do |ansible|
      ansible.playbook = "playbook/site.yml"
      ansible.groups = ansibleGroups
      ansible.limit = "edge"
      ansible.tags = "all"
      ansible.raw_arguments = [
        "-e", "@config/vagrant.config.yml"
      ]
    end
  end
end
