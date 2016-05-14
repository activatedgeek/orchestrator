# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'ipaddr'

$MESOS_MASTER_COUNT = 1
$MESOS_SLAVE_COUNT = 2
$IP_CIDR_PREFIX = "192.168.80.0/24"
$PLAYBOOK = ENV['PLAYBOOK'] || "site"
$TAGS = ENV['TAGS'] || "all"

$IP = IPAddr.new($IP_CIDR_PREFIX)
# skip first address
$IP = $IP.succ

# groups for ansible
ansibleGroups = {
  "mesos-master" => [],
  "mesos-slave" => [],
  "consul-server" => [],
  "bastion" => []
}

ansibleHostVars = {}

Vagrant.configure(2) do |config|
  config.vm.box = "activatedgeek/mesos"
  # config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # just use the default insecure key for POC purposes
  config.ssh.insert_key = false

  (1..$MESOS_MASTER_COUNT).each do |m_id|

    config.vm.define "m#{m_id}" do |master|
      master.vm.hostname = "m#{m_id}"
      ansibleHostVars[master.vm.hostname] = {
        "zookeeper_id" => m_id
      }
      ansibleGroups["mesos-master"].insert(-1, master.vm.hostname)
      ansibleGroups["consul-server"].insert(-1, master.vm.hostname)
      if m_id == 1
        ansibleGroups["bastion"].insert(-1, master.vm.hostname)
      end

      $IP = $IP.succ
      master.vm.network "private_network", ip: $IP.to_s

      master.vm.provider "virtualbox" do |vb|
        vb.name = master.vm.hostname
        vb.gui = false
        vb.cpus = 1
        vb.memory = "768"
      end
    end
  end

  (1..$MESOS_SLAVE_COUNT).each do |s_id|
    config.vm.define "s#{s_id}" do |slave|
      slave.vm.hostname = "s#{s_id}"
      ansibleGroups["mesos-slave"].insert(-1, slave.vm.hostname)

      $IP = $IP.succ
      slave.vm.network "private_network", ip: $IP.to_s

      slave.vm.provider "virtualbox" do |vb|
        vb.name = slave.vm.hostname
        vb.gui = false
        vb.cpus = 1
        vb.memory = "1792"
      end

      ##
      # attach provisioner to last node for parallel provisioning
      ##
      if s_id == $MESOS_SLAVE_COUNT
        slave.vm.provision :ansible do |ansible|
          ansible.playbook = "playbook/#{$PLAYBOOK}.yml"
          ansible.groups = ansibleGroups
          ansible.host_vars = ansibleHostVars
          ansible.limit = "all"
          ansible.tags = $TAGS
          ansible.raw_arguments = [
            "-e", "@config/vagrant.config.yml"
          ]
        end
      end
    end
  end
end
