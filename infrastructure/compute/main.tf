terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner       = var.owner
      Project     = var.project
      Environment = var.environment
    }
  }
}

resource "aws_security_group" "clumsy_bird" {
  description = "Clumsy Bird Security Group Access"
  name        = "${var.prefix}-security-group"

  vpc_id = data.tfe_outputs.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "clumsy_bird" {
  instance = aws_instance.clumsy_bird.id
  domain   = "vpc"
  tags = {
    "Name" = "${var.prefix}-${var.project}-${var.environment}"
  }
}

resource "aws_eip_association" "clumsy_bird" {
  instance_id   = aws_instance.clumsy_bird.id
  allocation_id = aws_eip.clumsy_bird.id
}

resource "aws_instance" "clumsy_bird" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = element(data.tfe_outputs.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.clumsy_bird.id]

  user_data = templatefile("${path.module}/application-files/deploy_app.sh", {})

  tags = {
    Name = "${var.prefix}-${var.project}-${var.environment}-instance"
  }
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket_prefix = "${var.prefix}-s3-${var.environment}"
  acl           = "private"
  versioning = {
    enabled = true
  }
}