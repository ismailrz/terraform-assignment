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
