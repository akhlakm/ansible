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
    ansible-playbook main.yml --list-tags

    # Run tag(s), example:
    ansible-playbook main.yml --tags setup,boot
```
