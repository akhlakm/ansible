#!/bin/bash

## Run as:
# curl -L https://raw.githubusercontent.com/akhlakm/ansible/main/setup.sh | bash

dnf update -y

# Ansible user account and sshd port
# ----------------------------------
read -p "Ansible user: " AN_USER
read -p "Ansible port: " AN_PORT

AN_USER=${AN_USER:-ansible}
AN_PORT=${AN_USER:-22}

echo "Setting up system for user: $AN_USER port: $AN_PORT"

# Enable NOPASSWD for the wheel/root group
echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Change sshd port to <ansible_port>
echo Port $AN_PORT >> /etc/ssh/sshd_config

# Create the ansible user
useradd ${AN_USER}
usermod -a -G wheel ${AN_USER}

# Create ansible user ssh directory
mkdir /home/${AN_USER}/.ssh

# Copy the ssh authorized key
cp /root/.ssh/authorized_keys /home/${AN_USER}/.ssh/

# Update permission
chown ${AN_USER} /home/${AN_USER}/.ssh/authorized_keys

# Install other packages
# ----------------------------------
dnf install -y nftables
dnf install -y epel-release
dnf install -y firewalld fail2ban

# Setup Firewall
# ----------------------------------
nft add table inet SSHD
nft 'add chain inet SSHD INPUT { type filter hook input priority 0; }'
nft add rule inet SSHD INPUT tcp dport $AN_PORT accept
nft list ruleset | tee -a /etc/sysconfig/nftables.conf

systemctl enable nftables

systemctl mask iptables

echo "Done! Please reboot and reconnect."
echo "ssh $AN_USER@$HOST -p $AN_PORT"
