#!/usr/bin/env bash
# Get the OpenMPI Environment running

mpiclients=()

for i in $*; do
   mpiclients+=($i)
done

# Connect to the clients and install OpenMPI
for client in "${mpiclients[@]}"
do
  ssh root@$client "yum install -y openmpi openmpi-devel"
done
