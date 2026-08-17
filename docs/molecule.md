# Molecule Testing

The node_monitoring Ansible role supports two deployment modes:

- systemd — runs the application as a Linux system service without containerization.
- docker — runs the application in a container.

The role is tested on two Linux distributions:

- Debian 12
- Rocky Linux 9

Molecule and Vagrant are used to create isolated virtual machines for testing the Ansible role.

## Molecule Scenario

The Molecule scenario is located in:

```text
roles/node_monitoring/molecule/default
