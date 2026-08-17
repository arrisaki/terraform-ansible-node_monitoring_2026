# Terraform Deployment

Terraform is used to automatically create the infrastructure required for deploying the `node-monitoring` service in Yandex Cloud.

The Terraform configuration is responsible for:

- creating an Ubuntu virtual machine;
- creating the required network interface;
- configuring SSH access to the virtual machine;
- preparing the infrastructure for deployment of the `node-monitoring` service using Ansible.

## Terraform Configuration

The main Terraform configuration is located in:

```text
main.tf
```

## 1. Initialize Terraform

Before working with the Terraform configuration, initialize the project:

```bash
terraform init
```

## 2. Validate the Configuration

Check the Terraform configuration for errors:

```bash
terraform validate
```

## 3. Review the Execution Plan

Before creating the infrastructure, review the planned changes:

```bash
terraform plan
```

This command shows which resources Terraform is going to create or modify.

## 4. Create the Infrastructure

Apply the Terraform configuration:

```bash
terraform apply
```

Terraform will display the planned changes and ask for confirmation.

After confirmation, Terraform creates the required infrastructure in Yandex Cloud.

The created virtual machine is then used for deployment of the `node-monitoring` service using Ansible.

## Verify the Virtual Machine

After `terraform apply` completes successfully:

1. Open Yandex Cloud.
2. Go to **Compute Cloud**.
3. Open the **Virtual machines** section.
4. Verify that the virtual machine was created successfully.

## Connect to the Virtual Machine

After the VM has been created, connect to it using SSH.

The exact SSH command depends on the username, IP address, and SSH key configured for the virtual machine.

## Verify the Node Monitoring Service

After connecting to the VM, check whether the `node-monitoring` container is running.

Run:

```bash
docker ps
```

The output should contain a running container named:

```text
node-monitoring
```

The application should expose port:

```text
8080
```

If the container is running and port `8080` is exposed, the deployment was completed successfully.
