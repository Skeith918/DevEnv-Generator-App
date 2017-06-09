#!/bin/bash
echo $1 > /opt/tools.txt
sed -i 's/,/\n/g' /opt/tools.txt

while read line; do
   /etc/init.d/$line start&
   sleep 3
done </opt/tools.txt

mkdir /var/run/sshd
echo 'root:$2' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "export VISIBLE=now" >> /etc/profile
/etc/init.d/ssh restart

/usr/sbin/sshd -D
