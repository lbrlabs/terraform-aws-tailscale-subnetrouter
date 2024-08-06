module "lbr-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name               = "lbr-subnetrouter-asg"
  cidr               = local.vpc_cidr
  enable_nat_gateway = true

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "lbr-subnet-router" {
  source              = "../../"
  name                = "lbr-subnet-router"
  instance_type       = "t3.micro"
  subnet_ids          = module.lbr-vpc.public_subnets
  ami_id              = data.aws_ami.ubuntu.id
  tailscale_auth_key  = var.tailscale_auth_key
  advertise_addresses = [module.lbr-vpc.vpc_cidr_block]
  public              = true
  vpc_id              = module.lbr-vpc.vpc_id
  additional_parts = [{
    filename     = "cloudwatch-agent"
    content_type = "text/x-shellscript"
    content      = <<-EOF
#!/bin/sh
wget https://amazoncloudwatch-agent.s3.amazonaws.com/debian/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i -E /tmp/amazon-cloudwatch-agent.deb
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux-lbr
EOF
  }]
}
