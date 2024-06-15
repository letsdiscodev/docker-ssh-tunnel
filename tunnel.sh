#!/bin/sh
ssh-keygen -A
sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config
echo -n "root:$PASSWORD" | chpasswd
/usr/sbin/sshd -D
