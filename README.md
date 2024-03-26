# Ansible Configurations

USAGE:

```sh
    # Install ansible
    brew install ansible || apt install ansible

    # Clone and setup the repository
    git clone https://github.com/akhlakm/ansible.git
    cd ansible
    git config core.hooksPath .githooks

    # View tags
    export PASS=<vault password>
    ansible-playbook -i "192.168.0.100," main.yml --list-tags

    # Run tag(s), example:
    ansible-playbook -i server.com, main.yml --tags setup,boot

    # Decrypt/encrypt the vault:
    ansible-vault decrypt vault.yml
    ansible-vault encrypt vault.yml
```

Run `ansible-playbook --help` for additional options.
