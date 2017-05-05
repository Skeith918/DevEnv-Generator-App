#!/bin/bash
if [ $INSTALLED = "0" ]
then
  while read line; do
    apt install -y $line
  done <packagescontainer.txt
  export INSTALLED=1
else
  while read line; do
    /etc/init.d/$line start
  done <packagescontainer.txt
  /usr/sbin/sshd -D
fi
