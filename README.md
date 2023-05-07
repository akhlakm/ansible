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

    # Decrypt/encrypt the vault:
    ansible-vault decrypt vault.yml
    ansible-vault encrypt vault.yml

    # Run on specific hosts, with the become pass prompt
    ansible-playbook main.yml --limit legion -K

```

Run `ansible-playbook --help` for additional options.
