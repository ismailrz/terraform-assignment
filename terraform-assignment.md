# Terraform Assignment: EC2 and S3 Resource Lifecycle

## Objective

Use Terraform to provision and clean up AWS resources — an EC2 instance and an S3 bucket — in the `us-east-1` region.

---

## Project Structure

```
terraform-assignment/
├── main.tf               # Provider, EC2 instance, and S3 bucket resources
├── variables.tf          # Input variable declarations
├── terraform.tfvars      # Input variable values
├── outputs.tf            # Output values after apply
└── terraform-assignment.md
```

---

## Configuration Files

### `main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_subnets" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

# EC2 Instance
resource "aws_instance" "terraform_assignment" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  subnet_id     = tolist(data.aws_subnets.available.ids)[0]

  tags = {
    Name    = "TerraformAssignment"
    Project = "Terraform-Assignment"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "terraform_assignment" {
  bucket = var.s3_bucket_name

  tags = {
    Name    = "TerraformAssignment"
    Project = "Terraform-Assignment"
  }
}
```

### `variables.tf`

```hcl
variable "s3_bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
  default     = "terraform-assignment-bucket-2026"
}
```

### `terraform.tfvars`

```hcl
s3_bucket_name = "terraform-assignment-bucket-2026"
```

### `outputs.tf`

```hcl
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.terraform_assignment.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.terraform_assignment.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_assignment.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_assignment.arn
}
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- AWS account with permissions to create EC2 and S3 resources
- AWS credentials configured:

```bash
aws configure
```

---

## Steps

### 1. Initialize

Downloads the AWS provider plugin.

```bash
terraform init
```

### 2. Plan

Previews the resources that will be created.

```bash
terraform plan
```

### 3. Apply

Provisions the EC2 instance and S3 bucket.

```bash
terraform apply
```

Type `yes` when prompted. After completion, Terraform prints the instance ID, public IP, and bucket name.

### 4. Verify in AWS Console

- **EC2:** AWS Console → EC2 → Instances → find `TerraformAssignment`
- **S3:** AWS Console → S3 → find `terraform-assignment-bucket-2026`

### 5. Destroy

Removes all created resources.

```bash
terraform destroy
```

Type `yes` when prompted.

---

## Resources Created

| Resource | Type | Region | Tags |
|----------|------|--------|------|
| EC2 Instance | t2.micro (Amazon Linux 2) | us-east-1 | Name=TerraformAssignment |
| S3 Bucket | Standard | us-east-1 | Name=TerraformAssignment |

---

## Notes

- The S3 bucket name must be globally unique. If `apply` fails with a name conflict, change the `default` value in `variables.tf`.
- The `aws_subnets` data source automatically selects an available subnet, handling cases where the default VPC subnets have been removed.
- Both resources are tagged with `Name = "TerraformAssignment"` and `Project = "Terraform-Assignment"` (bonus requirement).
