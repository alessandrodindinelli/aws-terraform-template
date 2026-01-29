# Terraform Template

> **Disclaimer**: This repository was written and tested to be used in the future, as a possible reference, if needed. I can't ensure that the code will continue to work as intended with future updates to the tools used. Enjoy 🤓

## Introduction

This repository provides a modular and extensible template for deploying AWS infrastructure using Terraform and Terragrunt.
It is structured to support multiple environments (e.g. dev, staging, prod) and follows best practices for infrastructure as code, including remote state management and environment isolation.

## Requirements

The following are the versions of the various tools used:

- AWS CLI - 2.13.14
- Terraform - 1.9.8
- Terragrunt - 0.82.3

## Structure

- **modules/**: Contains reusable Terraform modules for different infrastructure components:
  - **backend**: Sets up the S3 bucket and DynamoDB table for Terraform remote state and locking.
  - **common**: Handles common variables and provider configuration shared across modules.
  - **vpc**: Provisions a VPC, subnets, and related networking resources.
  - **ecs**: Deploys ECS clusters, services, task definitions, load balancers, and related IAM roles. Keep in mind that if you edit the JS code of the Lambda, you need to re-create the zip of the *ecs-scheduler.js* file.
  - **ecs-scheduler**: Schedules ECS service scaling (start/stop) using AWS Lambda and CloudWatch Events with personalized cron expressions.

- **terragrunt/**: Contains Terragrunt configuration for each environment and module, orchestrating the deployment order and wiring dependencies between modules.

## Usage

### Customize the parameters

- Edit the `terragrunt/backend/terragrunt.hcl` file to specify the string to be used to name the S3 bucket and DynamoDB table.
- Same thing, edit the `terragrunt/terragrunt.hcl` with the same string to utilize those resources for the other modules.
- Edit the `terragrunt/dev/*/terragrunt.hcl` files to customize variables for your environment.
- Add or modify services in the `ecs` module by editing the `services` input map.

### Authenticate to AWS

The first thing you should do is ensure you have access via your method of choice (e.g. the AWS CLI) to the AWS account you want to deploy this template into, so configure the credentials/role you need for your platform.
If you're not sure which credentials you're using in a certain environment, a useful command you can run is the following:

```sh
aws sts get-caller-identity
```

### Backend setup (one-time per environment)

Before deploying any infrastructure, initialize the backend for the remote state:

```sh
cd terragrunt/backend
terragrunt run-all apply --non-interactive
```

This will provision the S3 bucket and DynamoDB table required for remote state and locking.

### Deploy environment modules

Switch to the desired environment (e.g., `dev`) and apply all modules:

```sh
cd ../dev
terragrunt run-all apply --non-interactive
```

Terragrunt will:

- Deploy the `common` module to set shared variables and provider config.
- Deploy the `vpc` module for networking.
- Deploy the `ecs` module for compute and services.
- Deploy the `ecs-scheduler` module for scheduled scaling.

### Module Details

Each module is documented in its own `README.md` and supports input variables for customization. See:

- [`modules/backend/README.md`](modules/backend/README.md)
- [`modules/common/README.md`](modules/common/README.md)
- [`modules/vpc/README.md`](modules/vpc/README.md)
- [`modules/ecs/README.md`](modules/ecs/README.md)
- [`modules/ecs-scheduler/README.md`](modules/ecs-scheduler/README.md)
