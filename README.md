# Terraform Assignment: EC2 and S3 Resource Lifecycle

## Overview

This project uses Terraform to provision and destroy AWS resources — a `t2.micro` EC2 instance and an S3 bucket — in the `us-east-1` region.

## Project Structure

```
terraform-assignment/
├── main.tf               # Provider, EC2 instance, and S3 bucket resources
├── variables.tf          # Input variable declarations
├── terraform.tfvars      # Input variable values
├── outputs.tf            # Output values after apply
├── .gitignore
└── README.md
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- AWS account with permissions to create EC2 and S3 resources
- AWS CLI configured with credentials:

```bash
aws configure
```

## Usage

### 1. Clone the repository

```bash
git clone <repository-url>
cd terraform-assignment
```

### 2. Set variable values

Edit `terraform.tfvars` and set a unique S3 bucket name:

```hcl
s3_bucket_name = "your-unique-bucket-name"
```

### 3. Initialize

```bash
terraform init
```

### 4. Plan

```bash
terraform plan
```

### 5. Apply

```bash
terraform apply
```

Type `yes` when prompted.

### 6. Destroy

```bash
terraform destroy
```

Type `yes` when prompted.

## Resources

| Resource | Type | Region |
|----------|------|--------|
| EC2 Instance | t2.micro (Amazon Linux 2) | us-east-1 |
| S3 Bucket | Standard | us-east-1 |

## Tags

Both resources are tagged with:

```
Name    = "TerraformAssignment"
Project = "Terraform-Assignment"
```
