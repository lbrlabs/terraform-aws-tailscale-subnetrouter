<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 5.30)

- <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) (>= 2.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.61.0)

## Modules

The following Modules are called:

### <a name="module_asg"></a> [asg](#module\_asg)

Source: terraform-aws-modules/autoscaling/aws

Version: ~> 7.7

### <a name="module_tailscale-subnet-router"></a> [tailscale-subnet-router](#module\_tailscale-subnet-router)

Source: lbrlabs/tailscale/cloudinit

Version: 0.0.5

## Resources

The following resources are used by this module:

- [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_security_group_rule.allow_all_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_advertise_addresses"></a> [advertise\_addresses](#input\_advertise\_addresses)

Description: n/a

Type: `list(string)`

### <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id)

Description: n/a

Type: `string`

### <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type)

Description: n/a

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: n/a

Type: `string`

### <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids)

Description: n/a

Type: `list(string)`

### <a name="input_tailscale_auth_key"></a> [tailscale\_auth\_key](#input\_tailscale\_auth\_key)

Description: n/a

Type: `string`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_parts"></a> [additional\_parts](#input\_additional\_parts)

Description: Additional user defined part blocks for the cloudinit\_config data source

Type:

```hcl
list(object({
    filename     = string
    content_type = optional(string)
    content      = optional(string)
    merge_type   = optional(string)
  }))
```

Default: `[]`

### <a name="input_advertise_tags"></a> [advertise\_tags](#input\_advertise\_tags)

Description: n/a

Type: `list(string)`

Default: `[]`

### <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity)

Description: n/a

Type: `number`

Default: `2`

### <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_enable_ssh"></a> [enable\_ssh](#input\_enable\_ssh)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_max_size"></a> [max\_size](#input\_max\_size)

Description: n/a

Type: `number`

Default: `2`

### <a name="input_min_size"></a> [min\_size](#input\_min\_size)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_public"></a> [public](#input\_public)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_security_groups_ids"></a> [security\_groups\_ids](#input\_security\_groups\_ids)

Description: List of additional security group IDs to attach to the ASG instances

Type: `list(string)`

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: n/a

Type: `map(string)`

Default: `{}`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
