#!/bin/bash

HOST=$(hostname)
if [[ $1 = step1 ]]; then
  sudo mkdir -p /run/user/gluster/fs01 /mnt
  if [[ $HOST = manager01 ]]; then
    sudo gluster peer probe worker01
    sudo gluster peer probe worker02
  fi
  if [[ $HOST = worker01 ]]; then
    sudo gluster peer probe manager01
    sudo gluster peer probe worker02
  fi
  if [[ $HOST = worker02 ]]; then
    sudo gluster peer probe manager01
    sudo gluster peer probe worker01
fi

fi 

if [[ $1 = step2 ]]; then
  if [[ $HOST = manager01 ]]; then
    sudo gluster volume stop gfsvol1
    sudo gluster volume delete gfsvol1
    
    echo "Volume deleted, now creating again ";
    sudo gluster volume create gfsvol1 replica 3 transport tcp manager01:/run/user/gluster/fs01 worker01:/run/user/gluster/fs01 worker02:/run/user/gluster/fs01
    sudo gluster volume start gfsvol1
  fi
fi

if [[ $1 = step3 ]]; then
    sudo mount -t glusterfs ${HOST}:/gfsvol1 /mnt
    sudo mkdir -p /mnt/data
fi
