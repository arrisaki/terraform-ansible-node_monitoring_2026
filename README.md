# Terraform + Ansible Node Monitoring

This project automates the creation of a virtual machine in Yandex Cloud and the deployment of the node-monitoring service using Terraform and Ansible.

The Ansible role supports two deployment modes:

- systemd — runs the application as a Linux system service without containerization.
- docker — runs the application in a container.

The role is tested on:

- Debian 12
- Rocky Linux 9

For local role testing, Molecule and Vagrant are used.

## Project Structure

```text
.
├── main.tf
├── inventory.ini
├── playbook.yml
├── .gitignore
├── .terraform.lock.hcl
└── roles/
    └── node_monitoring/
        ├── defaults/
        ├── files/
        ├── handlers/
        ├── meta/
        ├── molecule/
        │   └── default/
        │       ├── molecule.yml
        │       ├── converge.yml
        │       └── verify.yml
        ├── tasks/
        ├── templates/
        ├── tests/
        ├── vars/
        ├── README.md
        └── Vagrantfile
