#!/usr/bin/env bash
# Get the NFS clients connected to the servers

nfsclients=()

for i in $*; do
   nfsclients+=($i)
done

# Connect to the clients and mount the shares
for client in "${nfsclients[@]}"
do
  ssh root@$client "mkdir /data1; mount nfs1:/data1 /data1; chown vagrant: /data1"
  ssh root@$client "mkdir /data2; mount nfs2:/data2 /data2; chown vagrant: /data2"
done
