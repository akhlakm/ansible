# Ansible Configurations

USAGE:

```sh
    # Install ansible
    brew install ansible || apt install ansible

    # Clone and setup the repository
    git clone https://github.com/akhlakm/ansible.git
    cd ansible
    git config core.hooksPath .githooks

    # Setup password
    vi .password

    # Install ansible collections
    ansible-galaxy collection install -r ansible-collections.yml

    # View tags
    ansible-playbook -i "192.168.0.100," main.yml --list-tags

    # Run tag(s), example:
    ansible-playbook -i server.com, main.yml --tags setup,boot

    # Decrypt/encrypt the configuration:
    ansible-vault decrypt config.yml
    ansible-vault encrypt config.yml
```

Run `ansible-playbook --help` for additional options.


## Initial Setup
To handover the control to ansible, the following things should be set first
by logging in using the `root` account.

```sh
# Edit the sudoers file
vi /etc/sudoers

# Enable NOPASSWD for the wheel/root group
%wheel  ALL=(ALL)       NOPASSWD: ALL

# Create the ansible user
useradd <ansible_user>
usermod -a -G wheel <ansible_user>

# Set a password, empty not allowed for sshd without PAM
passwd <ansible_user>

# Create ansible user ssh directory
mkdir /home/<ansible_user>/.ssh

# Copy the ssh authorized key
cp ~/.ssh/authorized_keys /home/<ansible_user>/.ssh/

# Update permission
chown <ansible_user> /home/<ansible_user>/.ssh/authorized_keys

# Update your system
dnf update | apt update

# Exit and reboot
reboot now
```
