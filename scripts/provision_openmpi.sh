#!/bin/sh
# Get the OpenMPI Environment running

mpiclients=()

for i in $*; do
   mpiclients+=($i)
done

# Connect to the clients and mount the shares
for client in "${mpiclients[@]}"
do
  ssh root@$client "yum install -y openmpi openmpi-devel"
  ssh root@$client "module load openmpi-$(uname -i)"
done
