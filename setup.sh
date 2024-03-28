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

echo "Please setup a password for the ansible user:"
passwd ${AN_USER}

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
dnf install -y epel-release dnf-automatic
dnf install -y firewalld fail2ban

# Setup Docker
# ----------------------------------
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Change sshd port of firewalld
# ----------------------------------
sed "/port/{s|22|$AN_PORT|}" /usr/lib/firewalld/services/ssh.xml > /etc/firewalld/services/ssh.xml

# Setup Services
# ----------------------------------
systemctl enable fail2ban
systemctl enable firewalld
systemctl enable dnf-automatic-install.timer
systemctl enable docker

echo -e "\nDone! Please reboot and reconnect:"
echo -e "\tssh $AN_USER@$HOSTNAME -p $AN_PORT"
