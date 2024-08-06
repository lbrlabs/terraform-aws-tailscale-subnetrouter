variable "name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_groups_ids" {
  description = "List of additional security group IDs to attach to the ASG instances"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "tailscale_auth_key" {
  sensitive = true
  type      = string
}

variable "advertise_tags" {
  type    = list(string)
  default = []
}

variable "advertise_addresses" {
  type = list(string)
}

variable "enable_ssh" {
  type    = bool
  default = false
}

variable "public" {
  type    = bool
  default = false
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "additional_parts" {
  description = "Additional user defined part blocks for the cloudinit_config data source"
  type = list(object({
    filename     = string
    content_type = optional(string)
    content      = optional(string)
    merge_type   = optional(string)
  }))
  default = []
}
