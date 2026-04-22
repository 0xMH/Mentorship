
# I will Test Things for simple setup
# It is Just private & public Subnets
# two EC2 run simple web application behind ALB
# ALB that accept traffic in public subnets
# private subent instances can access internet through NAT Gateway

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "amx-bucket-724"
    key            = "test/terraform.tfstate"
    region         = "eu-west-1"
    use_lockfile = true
    encrypt        = true
  }
}


provider "aws" {
  region = "eu-west-1"

  # assume a role
  assume_role {
    role_arn = "arn:aws:iam::408502715955:role/TerraformRole_v1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}


module "vpc" {
    source = "./VPC"
    cidr_block = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    map_public_ip_on_launch = true

    private_subnet_cidrs = ["10.0.100.0/24", "10.0.101.0/24"]
    one_nat_gateway_per_az = true

    azs = ["eu-west-1b", "eu-west-1c"]

}


module "sg" {
  source = "./SG"
  vpc_id = module.vpc.vpc_id
  
  security_groups = [
    {
      name        = "ec2-sg"
      description = "Security group for ec2"
      ingress_rules = [
        {
          cidr_block  = module.vpc.cidr_block
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
        },
        {
          cidr_block  = module.vpc.cidr_block
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
        }
      ]
      egress_rules = [
        {
          cidr_block  = "0.0.0.0/0"
          ip_protocol = "-1"
        }
      ]
    },
    {
      name        = "alb-sg"
      description = "Security group for ALB"
      ingress_rules = [
        {
          cidr_block  = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
        }
      ]
      egress_rules = [
        {
        cidr_block = "0.0.0.0/0"
        ip_protocol = "-1"
        }
      ]
    }
  ]
}


module "EC2" {
  source = "./EC2"
  region = "eu-west-1"
  instance_type = "t3.micro"
  subnet_ids = module.vpc.private_subnets
  security_group_id = module.sg.security_group_ids[0]
  ami_id = data.aws_ami.ubuntu.id
  docker_image_url = "alimx07/flask-app:v1"
  key_name = "bastion-shh" # typo
}

module "ALB" {
  source = "./ALB"
  name = "test-alb"
  load_balancer_type = "application"
  security_groups = [module.sg.security_group_ids[1]]
  subnets = module.vpc.public_subnets
  target_port = 8080
  listener_port = 80
  vpc_id = module.vpc.vpc_id
  target_ids = module.EC2.ec2_ids
}

output "alb_url" {
  value = module.ALB.dns_name
}