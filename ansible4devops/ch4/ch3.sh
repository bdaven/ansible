ansible multi -a "hostname"

ansible multi -a "df -h"

ansible multi -a "date"

# Install chrony
ansible multi -b -m yum -a "name=chrony state=present"

# Start chrony on startup
ansible multi -b -m service -a "name=chronyd state=started enabled=yes"

# Enable chrony tracking
ansible multi -b -a "chronyc tracking"

# install python3-pip
ansible app -b -m yum -a "name=python3-pip state=present"

# install django
ansible app -b -m pip -a "name=django<4 state=present"

# check and show django version
ansible app -a "python -m django --version"

# install maria db
ansible db -b -m yum -a "name=mariadb-server state=present"

# start mariadb at startup
ansible db -b -m service -a "name=mariadb state=started enabled=yes"

# Configure the system firewall to ensure only the app servers can access the database

ansible db -b -m yum -a "name=firewalld state=present"

ansible db -b -m service -a "name=firewalld state=started enabled=yes"

ansible db -b -m firewalld -a "zone=database state=present permanent=yes"

ansible db -b -m firewalld -a "source=192.168.60.0/24 zone=database state=enabled permanent=yes"

ansible db -b -m firewalld -a "port=3306/tcp zone=database state=enabled permanent=yes"

# Configure MariaDB

ansible db -b -m yum -a "name=python3-PyMySQL state=present"

ansible db -b -m mysql_user -a "name=django host=% password=12345 priv=*.*:ALL state=present"

# Stop and Start chrony

ansible app -b -a "systemctl status chronyd"

ansible app -b -a "service chronyd restart" --limit "192.168.60.4"

# Limit hosts with a simple pattern (asterisk is a wildcard)
ansible app -b -a "service ntpd restart" --limit "*.4"

# Limit hosts with a regular expression (prefix with a tilde)
ansible app -b -a "service ntpd restart" --limit ~".*\.4"

# User and Group Management
# Add an admin group on the app servers
ansible app -b -m group -a "name=admin state=present"

# add the user johndoe to the app servers
# home folder in /home/johndoe
ansible app -b -m user -a "name=johndow group=admin createhome=yes"

# remove the user johndoe
ansible app -b -m user -a "name=johndoe state=absent remove=yes"

# install git
ansible app -b -m package -a "name=git state=present"

# get information about a file
ansible multi -m stat -a "path=/etc/environment"

# copy a file to the servers
ansible multi -m copy -a "src=/etc/hosts dest=/tmp/hosts"

# retrieve a file from the servers
ansible multi -b -m fetch -a "src=/etc/hosts dest=/tmp"

# create directories and files
ansible multi -m file -a "dest=/tmp/test mode=644 state=directory"

# create a symlink (set state=link)
ansible multi -m file -a "src=/src/file dest=/dest/symlink state=link"

# delete directories and files
ansible multi -m file -a "dest=/tmp/test state=absent"

# update servers asynchronously with asynchronous jobs
ansible multi -b -B 3600 -P 0 -a "yum -y update"

# 192.168.60.5 | CHANGED => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python"
#     },
#     "ansible_job_id": "66203883954.7008",
#     "changed": true,
#     "finished": 0,
#     "results_file": "/root/.ansible_async/66203883954.7008",
#     "started": 1
# }

# review the async job status
ansible multi -b -m async_status -a "jid=66203883954.7008"

# show the tail of the logs
ansible multi -b -a "tail /var/log/messages"

ansible multi -b -m shell -a "tail /var/log/messages | grep ansible-command | wc -l"

# manage cron jobs
# add job
ansible multi -b -m cron -a "name='daily-cron-all-servers' hour=4 job='/path/to/daily-script.sh'"

# remove job
ansible multi -b -m cron -a "name='daily-cron-all-servers' state=absent"

# deploy a version controlled application via git
ansible app -b -m git -a "repo:git://example.com/path/to/repo.git dest=/opt/myapp update=yes version=1.2.4"

# install git
ansible app -b -m package -a "name=git state=present"

# run an application
ansible app -b -a "/opt/myapp/update.sh"

ansible app -b -a "yum update"








