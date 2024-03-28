#!/bin/bash
set -e          # exit on error
set -x          # show the command being executed

# Ansible user account and sshd port
# ----------------------------------
read -p "Ansible user name: " AN_USER
read -p "Ansible SSH port: " AN_PORT

AN_USER=${AN_USER:-ansible}
AN_PORT=${AN_PORT:-22}

echo "Setting up system for user: $AN_USER port: $AN_PORT"

# Update the system packages
# ----------------------------------
dnf update -y

# Enable NOPASSWD for the wheel/root group
echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Create the ansible user
useradd ${AN_USER}
usermod -a -G wheel ${AN_USER}

# Make sure sshd installed
dnf install -y openssh-server

# Change sshd port to <ansible_port>
echo Port $AN_PORT >> /etc/ssh/sshd_config

# Create ansible user ssh directory
mkdir /home/${AN_USER}/.ssh

# Copy the ssh authorized key
cp /root/.ssh/authorized_keys /home/${AN_USER}/.ssh/ || echo "No ssh key found."

# Update permission
chown ${AN_USER} /home/${AN_USER}/.ssh/authorized_keys || echo "Please add authorized_keys manually."

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

# Setup Services
# ----------------------------------
systemctl enable nftables
systemctl enable sshd
systemctl enable firewalld
systemctl enable fail2ban
systemctl disable iptables || echo
systemctl mask iptables

echo -e "\nDone! Please reboot and reconnect:"
echo -e "\tssh $AN_USER@$HOST -p $AN_PORT"
