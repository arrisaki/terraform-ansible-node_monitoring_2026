Terraform + Ansible Node Monitoring
This project automates the creation of a virtual machine in Yandex Cloud and the deployment of the node-monitoring service using Terraform and Ansible.
The Ansible role supports two deployment modes:
systemd — runs the application as a Linux system service without containerization.
docker — runs the application in a container.
The role is tested on:
Debian 12
Rocky Linux 9
For local role testing, Molecule and Vagrant are used.
Project Structure
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
Molecule Testing
The Molecule scenario is located in:
roles/node_monitoring/molecule/default
Main scenario files:
molecule.yml — describes the virtual machines used for testing.
converge.yml — applies the Ansible role.
verify.yml — performs the final verification of the deployed role.
Systemd Deployment Mode
To run the role in systemd mode, set the following variable in:
roles/node_monitoring/defaults/main.yml
deploy_mode: systemd
The variable should not be redefined in vars/main.yml, because variables defined in vars have higher priority.
In this mode, the role performs the following actions:
installs required Python packages;
creates the application directory;
copies app.py;
copies requirements.txt;
creates a Python virtual environment;
creates a systemd unit file;
performs daemon-reload;
starts the node-monitoring service.
Create the Test Environment
Run:
molecule create
This creates two virtual machines with different Linux distributions using Vagrant.
Check the created instances:
molecule list
Apply the Ansible role:
molecule converge
Molecule applies the role to both virtual machines and executes the tasks defined in the role. A successful run should finish with return code 0.
Connect to the Test Machines
Debian:
molecule login -h debian-instance
Rocky Linux:
molecule login -h redhat-instance
Verify Systemd Deployment
Inside the VM, check the service:
sudo systemctl status node-monitoring
The service should have the status:
active (running)
The application listens on port 8080. Check it with:
ss -tulnp | grep 8080
If the Python process is listening on 0.0.0.0:8080, the application has started successfully.
Docker / Podman Deployment Mode
If the systemd scenario was previously executed, destroy the existing Molecule environment first:
molecule destroy
Then change the deployment mode in:
roles/node_monitoring/defaults/main.yml
to:
deploy_mode: docker
After that, recreate the virtual machines and apply the role:
molecule create
molecule converge
On Debian, the application runs in Docker.
Check the container with:
docker ps
A successfully deployed container should appear with the name:
node-monitoring
On Rocky Linux 9, Podman is used instead of Docker. The role therefore contains separate Podman tasks such as:
podman_build.yml
podman_run.yml
Check the container on Rocky Linux with:
sudo podman ps -a
The node-monitoring container should be running and expose port 8080.
Infrastructure Deployment with Terraform
Terraform is used to automatically create the infrastructure required to deploy the node-monitoring service in Yandex Cloud.
The workflow includes:
creation of an Ubuntu virtual machine;
creation of network interfaces;
SSH access configuration;
deployment of the node-monitoring service using Ansible.
1. Initialize Terraform
terraform init
2. Validate the Configuration
terraform validate
3. Review the Execution Plan
terraform plan
4. Create the Infrastructure
terraform apply
After confirmation, Terraform creates the virtual machine and starts the Ansible deployment process.
Verification in Yandex Cloud
After terraform apply completes:
Open Yandex Cloud.
Go to Compute Cloud.
Open the Virtual machines section.
Verify that the VM was created successfully.
Connect to the VM using SSH.
Check that the node-monitoring container is running.
For Docker:
docker ps
The running container should expose port 8080.
Technologies
Terraform
Yandex Cloud
Ansible
Molecule
Vagrant
Docker
Podman
systemd
Python
Debian 12
Rocky Linux 9
Purpose
The project demonstrates automated infrastructure provisioning and service deployment using Infrastructure as Code and configuration management tools.
Terraform is responsible for infrastructure provisioning, while Ansible is responsible for configuring the target system and deploying the node-monitoring application. Molecule is used to test the Ansible role on different Linux distributions before deployment.
