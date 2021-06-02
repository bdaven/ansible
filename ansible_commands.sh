# basic ping
ansible windows -m win_ping

# basic gather facts
ansible windows -m setup

# Display facts from all hosts
ansible windows -m ansible.builtin.setup

# Display facts from all hosts and store them indexed by I(hostname) at C(/tmp/facts).
# ansible all -m ansible.builtin.setup --tree /tmp/facts
ansible windows -m ansible.builtin.setup --tree ~/dev/ansible/inventory/output

# inventory playbook
ansible-playbook inventory/main.yml

# inventory with extended facts
ansible 192.168.200.6 -m setup -a fact_path=c:/custom_facts

