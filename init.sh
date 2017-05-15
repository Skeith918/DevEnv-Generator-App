#!/bin/bash
while read line; do
   /etc/init.d/$line start&
   sleep 3
done </opt/packages.txt
/usr/sbin/sshd -D
