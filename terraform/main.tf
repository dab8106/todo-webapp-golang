provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "2023"
  ami                    = "ami-01eccbf80522b562b"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}