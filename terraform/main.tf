provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "selected" {
  default = true
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
}

module "ec2_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 2
  name           = "app-server"
  ami            = "ami-01eccbf80522b562b"
  instance_type  = "t2.micro"
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  alb_name        = "my-alb"
  vpc_id          = "vpc-0123456789abcdef" # Replace with your VPC ID
  security_groups = [module.ec2_instances.security_group_id]
  subnets = data.aws_subnet_ids.selected.ids

  listener = [
    {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
  ]
}

output "alb_dns_name" {
  value = module.alb.this_alb_dns_name
}

resource "aws_lb_target_group_attachment" "ec2_attachment" {
  count = length(module.ec2_instances.private_ip)

  target_group_arn = module.alb.this_alb_target_group_arn
  target_id        = module.ec2_instances.private_ip[count.index]
  port             = 80
}
