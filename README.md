Vagrant Mesh/3D Torus Network for an HPC Cluster Environment
============================================================

This repository contains a setup forVagrant, the VM automation and managment wrapper, setting up a virtual HPC cluster environment with compute and dedicated service nodes (NFS, login, workload management) which are connected via a 3D torus network/mesh.

Needed Software
---------------

* [Ruby](https://www.ruby-lang.org) (Version 2.2.2 or later)
* [Vagrant](https://www.vagrantup.com) (Version 1.7.2 or later)
* [Packer](https://www.packer.io) (Version 0.8.2 or later)
* [VirtualBox](https://www.virtualbox.org) (Version 4.3.30 or later)
* [Serverspec](http://serverspec.org) (Version 2.2.0 or later)
* [Univa Grid Engine](http://www.univa.com) (Version 8.2.0) (Download the trial tar.gz. files to the root of this directory)


The Torus Network
-----------------
For this project we chose a directly connected network, ie no external switches or routers are used - each of the hosts is directly connected to it's nearest neighbors and has OSPF routing enabled. OSPF was chosen to propagate the torus topology within the cluster. Neighbors are within the same L2 (Ethernet) and L3 networks (IP). 

As described above we are using 3D Torus to connect the compute hosts with each other. There are a total of 27 compute nodes in a 3x3x3 grid with 'wrap around' links at the edges forming a torus. The network is robust against failure of individual links as routing information is exchanged in a configurable time period via the routing protocol. The 3D torus needs a total of 6 links/network interface cards for every compute node. There are a total of 162 point to point conections within the torus.

The service nodes (NFS-servers, login-Nodes, queue master) are connected to individual hosts configurable via the central *cluster.yml* configuration file. The idea of using a 3D yorus network as an interconnect was also used by Christopher L. Lydick in his [Master thesis](http://krex.k-state.edu/dspace/handle/2097/808). We implemented his IP address generation algorithm for our torus.

The Flat Network
----------------
Apart form the torus network, an additional network with a NAT configuration is present. This network is used for external connectivity of the nodes and for SSH access from vagrant. 

* Green lines are edge connections.
* Blue lines are are normal connections between the hosts.
* Black lines are connections to service nodes.

![Torus Network Front](./images/torus_front.png)
This picture shows the torus network.

![Torus Network Above](./images/torus_above.png)
Edge wrap around links.

![Torus Network Cross](./images/torus_cross.png)


Start by Generating the Base Box Image
--------------------------------------
In order to spin this up, you'll need a vagrant base box that is the foundation of all the images used furhter on. For this we employed Packer. The packar scripts are complemented with a set of serverspec unit tests making sure that the box can be used further on.

Go into the "packer" directory and run

```
[user@host packer]$ rake
Rakefile for creating Box with packer

rake [options]

Options:
   *) build -- Builds the box from template
   *) check -- Checks if the box config is correct
   *) buildcheck -- Builds and checks the box
```

For running the unit tests run rake with the *buildcheck* option:

```
[user@host packer]$ rake buildcheck
virtualbox-iso output will be in this color.

...

Machine build correctly. File: centos6-x64.box

...

Finished in 3.74 seconds (files took 38.6 seconds to load)
8 examples, 0 failures

Machine installed correctly
```

After the machine has been built, rake should report that the machine is fine. Now the box is tested if all required porgrams are installed, necessary settings are present and if the vagrant users exist and is able to login via public key over ssh. If it ends with 'Machine installed correctly' everything is fine and the machine is ready to be used.

Add the file *centos6-x64.box* to the vagrant box list:

```sh
[user@host packer]$ vagrant box add centos6 centos6-x64.box
```

Starting up the Cluster
-----------------------

After the base box wascreated and imported, running

```sh
[user@host ~]$ vagrant up
```

in the directory where the Vagrantfile is located will spin up a cluster with 35 hosts (27 execution hosts, one login nodes, two nfs servers, one queue master/scheduler node). Make sure to adjust the memory parameters and the number of vCPUs that are assigend to the nodes in the config file. Running this on a small laptop will bring it to it's knees pretty hard, having a decent server with plenty of RAM (20GB +) is recommended.

Running the Cluster Unit Test Suite
-----------------------------------

A *Serverspec* unit test suite is present to check if all hosts are available, if the routing demons are running and if it's possible to submit compute jobs to the cluster.

Configuring the host's SSH client local fonfiguration for the cluster node names

```
[user@host ~]$ vagrant ssh config > ~/.ssh/config
```

Now it"s possible to connect via SSH to any of the node via 

```
[user@host ~]$ ssh login1
```
Configuring the serverspec environment.

```sh
[user@host serverspec]$ ls -al
total 32
drwxr-xr-x   7 user  group   238 Jul 31 15:13 .
drwxr-xr-x  21 user  group   714 Aug  5 11:29 ..
-rw-r--r--   1 user  group    99 Jul 31 15:13 Gemfile
-rw-r--r--   1 user  group  5619 Jul 31 15:13 Rakefile
-rw-r--r--   1 user  group   213 Jul 31 15:13 hosts
drwxr-xr-x   8 user  group   272 Jul 31 15:13 spec
drwxr-xr-x   6 user  group   204 Jul 31 15:13 viewer
```

Run the following command to install the dependencies

```
[user@host serverspec]$ bundle install
```
Because of the big number of checks, we included a viewer (Thanks to [Vincent Bernat](https://github.com/vincentbernat/serverspec-example)) to display the results of the tests. This step can be left out if the serverspec results are not of interest.

To configure the viewer (here [nginx](http://nginx.org) (Version 1.8.0)) we added following configuration file:

```
[user@host ~]$ cat /etc/nginx/conf.d/serverspec.conf
server {
   listen 80;
   server_name host.intern default;

   location / {
      root /path/to/serverspec/viewer;
      index index.html;
   }

   location /reports {
      autoindex on;
      root /path/to/serverspec;
      gzip_static always;
      gzip_http_version 1.0;
      gunzip on;
   }
}
```

Now everything is configured and one can now run serverspec and check the cluster with following command:

```
[user@host serverspec]$ bundle exec rake spec -j 32 -m
```

Options:

* -j $num ... How many paralell tasks can be started.
* -m ... Start rake multithreaded.

After the test has finished one can start the webserver and verify that the tests ran fine. If all tests are green the cluster works correctly and the following should be seen

![Serverspec Viewer](./images/serverspec_viewer.png)

How things are tied together
----------------------------

* First the values from central configuration file *cluster.yml* are read.
* Next provision starts for the service NFS and login nodes.
* Now we are able to setup the compute nodes, but first the IP addresses need to be calculated for each of the interfaces.
* When the node setup is finished, provisioning of the queue master host starts. The master connects to each hosts and installs the execution deamon, configures the NFS clients to connect to all of NFS servers.

Unit Test Overview
------------------

We've got two different types of serverspec tests in this project. The first serverspec test is when you"re going to build the base box file for the cluster. This test is based on the serverspec plugin for our provisioner vagrant. After the build process of the machine is finished you can run the test via rake. It spins up an instance of the build vm and then checks:
* If there is a root and a vagrant user.
* If SELinux is disabled.
* If [EPEL](https://fedoraproject.org/wiki/EPEL) is installed and configured.
* If all necessary programs are installed.
* If the passwordless ssh authentification for vagrant is configured.
* If the VirtualBox Additions are installed and enabled.

The second serverspec suit tests the cluster when its up and running. It checks:
* If all hosts are reachable and the hops between them do not exceed 4 hosts and if the routing daemon is working.
* If the login nodes have the correct path set and if the job submission is possible.
* If the queue master node has a correct path and if the qmaster process is running.
* If the NFS nodes have the nfs-tools installed and if the exports are set correctly.
* If the compute nodes have the correct $PATH set and if the execd daemon is running.

The results of the second test are not visible in the console they are written to the reports directory and if you configured the webserver correctly it should list the files from that directory on this website and you can click onto a results-file and check if everything is working.

Examples
--------

To check how many execution hosts are available run *qhost*:

```sh
[vagrant@login1 ~]$ qhost
HOSTNAME                ARCH         NCPU NSOC NCOR NTHR NLOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
----------------------------------------------------------------------------------------------
global                  -               -    -    -    -     -       -       -       -       -
node1                   lx-amd64        1    1    1    1  0.03  238.4M   53.7M  791.0M  100.0K
node2                   lx-amd64        1    1    1    1  0.06  238.4M   53.9M  791.0M   96.0K
...
```

To check if the nodes routing daemon is working run:

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
Todo
----
Please feel free to contribute to this project! Two things we are looking for

* Use an open source direclty installable work load manager (like SLURM)
* Offer options to use other IGPs like IS-IS instead of OSPF



Special Thanks
--------------

* Petar Forai
* Georg Rath
* Christopher L. Lydick
* Vincent Bernat (Serverspec Viewer)
