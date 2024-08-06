module "tailscale-subnet-router" {
  source           = "lbrlabs/tailscale/cloudinit"
  version          = "0.0.5"
  auth_key         = var.tailscale_auth_key
  enable_ssh       = var.enable_ssh
  hostname         = var.name
  advertise_tags   = var.advertise_tags
  advertise_routes = var.advertise_addresses
  accept_routes    = true
  max_retries      = 10
  retry_delay      = 10
  additional_parts = var.additional_parts
}

resource "aws_security_group" "sg" {
  #checkov:skip=CKV2_AWS_5:Security groups is attached to the ASG
  name        = "${var.name}-sg"
  description = "Security group for Tailscale subnet router ${var.name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  description       = "allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.7"

  name = var.name

  min_size                        = var.min_size
  max_size                        = var.max_size
  desired_capacity                = var.desired_capacity
  ignore_desired_capacity_changes = true
  wait_for_capacity_timeout       = 0
  health_check_type               = "EC2"
  vpc_zone_identifier             = var.subnet_ids


  launch_template_name        = "lt-${var.name}"
  launch_template_description = "Launch template for Tailscale subnet router ${var.name}"
  update_default_version      = true

  image_id          = var.ami_id
  instance_type     = var.instance_type
  ebs_optimized     = true
  security_groups   = concat([aws_security_group.sg.id], var.security_groups_ids)
  enable_monitoring = var.enable_monitoring
  network_interfaces = var.public ? [{
    associate_public_ip_address = true
    delete_on_termination       = true
  }] : []

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 100
      instance_warmup        = 100
    }
  }

  create_iam_instance_profile = true
  iam_role_name               = "iam-${var.name}"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for Tailscale subnet router ${var.name}"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    CloudwatchAgentAdminPolicy   = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
    AutoScalingFullAccess        = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  }

  user_data = module.tailscale-subnet-router.rendered

  tags = var.tags
}
