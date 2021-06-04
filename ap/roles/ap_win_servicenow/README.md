Role Name
=========

ap_win_servicenow.yml

Description
-----------

Role designed to copy a powershell script to custom_facts location.
Script runs with custom fact variables being past to gather facts.
Facts are then pasted via REST API to ServiceNow.

Version
-------

0.1.0

Requirements
------------

Playbook is setup as an ansible role.
ap_win_servicenow.yml


Role Variables
--------------

none

Dependencies
------------

none

Example Playbook
----------------

# ansible.cfg
[defaults]
inventory = hosts.ini
host_key_checking = false
command_warnings = false

# hosts.ini
[windows]
192.168.200.30
192.168.200.31

[windows:vars]
ansible_user = vagrant
ansible_password = "vagrant"
ansible_port = 5985
ansible_connection = winrm
ansible_winrm_server_cert_validation = ignore

# Example
ansible-playbook auspost-windows/ap_win_servicenow.yml

License
-------

BSD

Author Information
------------------

Barry Davenport

Tree
-----

.
├── ap_win_servicenow.yml
└── roles
   └── ap_win_servicenow
        ├── README.md
        ├── defaults
        │   └── main.yml
        ├── files
        │   └── custom_facts.ps1
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   ├── custom_facts_1_setup_dir.yml
        │   ├── custom_facts_2_gather.yml
        │   ├── custom_facts_3_register_facts.yml
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml