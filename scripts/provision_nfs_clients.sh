#!/usr/bin/env bash
# Get the NFS clients connected to the servers

nfsclients=()

for i in $*; do
   nfsclients+=($i)
done

# Connect to the clients and mount the shares
for client in "${nfsclients[@]}"
do
  ssh root@$client "yum install -y nfs-utils"
  ssh root@$client "mkdir /data0; mount nfs1:/data /data0; chown vagrant: /data0"
  ssh root@$client "mkdir /data1; mount nfs2:/data /data1; chown vagrant: /data1"
done
