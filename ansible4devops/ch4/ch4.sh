# Run playbook from the current directory
ansible-playbook playbook.yml

# Run playbook with limit filter to hosts group "webservers"
ansible-playbook playbook.yml --limit webservers

# Run playbook with limit filter to one particular host
ansible-playbook playbook.yml --limit xyz.example.com

# Run playbook with list-hosts, showing what hosts are to be affected
ansible-playbook playbook.yml --list-hosts

# Run playbook with setting user (--user or -u)
ansible-playbook playbook.yml --usr=johndoe

# Run playbook with sudo password (--ask-become-pass or -K)
# (--become or -b)
# (--become-user)
# (--ask-pass)
ansible-playbook playbook.yml --become --become-user=janedoe --ask-become-pass

# Run playbook with custom inventory file (--inventory=PATH or -i PATH)
ansible-playbook playbook.yml --inventory /home/hosts.ini

# Run playbook with verbose mode (--verbose or -v or -vvv)
ansible-playbook playbook.yml --verbose

# Run playbook with additional variables (--extra-vars=VARS or -e VARS)
ansible-playbook playbook.yml --extra-vars "key=value, key=value"

# Run playbook concurrently on hosts (--forks=NUM or -f NUM)
ansible-playbook playbook.yml --forks=5

# Run playbook using a particular connection type (--connection=TYPE or -c TYPE)
ansible-playbook playbook.yml --connection=ssh

# Run playbook in check mode 'Dry Run' (--check)
ansible-playbook playbook.yml --check

# Test run

ansible-playbook playbook2.yml

ansible-playbook playbook3.yml

# Query remote machine
ansible all -m shell -a 'echo $HOSTNAME'

# Query local machine
ansible all -m shell -a "echo $HOSTNAME"

