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
To handover the control to ansible, the following intialization should be done first
by logging into a new machine using the `root` account.

```sh
# Update your system
dnf update

# Enable NOPASSWD for the wheel/root group
echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Change sshd port to <ansible_port>
echo Port 22 >> /etc/ssh/sshd_config

# Create the ansible user
useradd <ansible_user>
usermod -a -G wheel <ansible_user>

# Create ansible user ssh directory
mkdir /home/<ansible_user>/.ssh

# Copy the ssh authorized key
cp ~/.ssh/authorized_keys /home/<ansible_user>/.ssh/

# Update permission
chown <ansible_user> /home/<ansible_user>/.ssh/authorized_keys

# Open the <ansible_port>
nft 'add table inet SSHD'
nft 'add chain inet SSHD INPUT { type filter hook input priority 0; }'
nft 'add rule inet SSHD INPUT tcp dport 22 accept'
nft list ruleset | tee -a /etc/sysconfig/nftables.conf

systemctl enable nftables
systemctl mask iptables

# Reboot and exit
reboot now
```

Now update the `ansible_user` and `ansible_port` in `config.yml`
and run the `server.yml` playbook.
