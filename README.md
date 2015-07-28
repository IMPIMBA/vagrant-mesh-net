Vagrant Mesh Network with Univa Grid Engine
===========================================

This repository contains a yaml, vagrant and other configuration files for setting up a virtual HPC Cluster Environment.
The execution hosts are connected via a 3D Cube Mesh Network.

Needed Software
---------------

* Vagrant (Version 1.7.2 or later)
* Packer (Version 0.8.2 or later)
* VirtualBox (Version 4.3.30 or later)

Create the base box
-------------------

Go into the "packer" directory and run

```sh
[user@host packer]$ packer build template_CentOS6.json
```

After that a *centos6-x64.box* is created. Now add this file to the vagrant box list:

```sh
[user@host packer]$ vagrant box add centos6 centos6-x64.box
```

Starting up the HPC Cluster
---------------------------

After you created and imported the base box, you just have to say

```sh
[user@host ~]$ vagrant up
```

in the directory where the Vagrantfile is located.

How it works
------------

* First the execution Hosts are set up, and configured to have a working "DNS" and "Routing" service.
* After that the NFS-Servers are setup, and all other machines are are configured to connect to them on specified path.
* Now the Univa Grid Engine is installed.
* Login and the submit of jobs now only works loginnodes.

Examples
--------

To check how many execution hosts are available use *qhost*:

```sh
[vagrant@login1 ~]$ qhost
HOSTNAME                ARCH         NCPU NSOC NCOR NTHR NLOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
----------------------------------------------------------------------------------------------
global                  -               -    -    -    -     -       -       -       -       -
node1                   lx-amd64        1    1    1    1  0.03  238.4M   53.7M  791.0M  100.0K
node2                   lx-amd64        1    1    1    1  0.06  238.4M   53.9M  791.0M   96.0K
...
```

To check if the nodes routing daemin is working run:

```sh
[vagrant@login1 ~]$ sudo birdc show ospf topology all
BIRD 1.3.8 ready.

area 0.0.0.0

  router 17.0.0.1
    distance 30
    network 17.0.0.0/30 metric 10
    network 17.0.32.0/30 metric 10
    network 17.0.0.4/30 metric 10
    network 17.0.2.4/30 metric 10
    network 17.0.0.8/30 metric 10
    network 17.0.0.40/30 metric 10
    network 17.1.0.0/30 metric 10

  router 17.0.0.2
    distance 30
...
```
