#!/usr/bin/env bash
# Get the NFS Server running

# Connect to the servers and prepare them
mkdir "/data$(hostname | tr -d '\n' | tail -c 1)"
echo "# This is a static content generated by provision_nfs_server" > /etc/exports
echo "/data$(hostname | tr -d '\n' | tail -c 1) 17.0.0.0/8(rw,async,no_root_squash,no_subtree_check)" >> /etc/exports
service rpcbind start
service nfs start
