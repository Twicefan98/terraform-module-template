variable "global" {
    type = object({
        app = string
        env = string

        vpc = object({
            id = string
        })

        tags = object({
            Project = string
            Owner = string
            Environment = string
        })
    })
}

variable "config" {
  type = object({
        name = string
        update_default_version = bool
        image_id = string
        key_name = string
        instance_type = string

        block_device_mappings = object({
            device_name = string
            ebs = object({
                delete_on_termination = bool
                volume_size = string
                volume_type = string
            })
        })

        network_interfaces = object({
            associate_public_ip_address = bool
            delete_on_termination = bool
            subnet_id = string
        })

        security_group = object({
            name = string
            description = string

            ingress = list(object({
                from_port = number
                to_port = number
                protocol = string
            }))
        })
  })
}

data "aws_vpc" "default" {
    id = var.global.vpc.id
}

resource "aws_launch_template" "default" {
    name = var.config.name
    update_default_version = var.config.update_default_version
    image_id = var.config.image_id
    key_name = var.config.key_name
    instance_type = var.config.instance_type

    block_device_mappings {
        device_name = var.config.block_device_mappings.device_name
        ebs {
            delete_on_termination = var.config.block_device_mappings.ebs.delete_on_termination
            volume_size = var.config.block_device_mappings.ebs.volume_size
            volume_type = var.config.block_device_mappings.ebs.volume_type
        }
    }

    network_interfaces {
        associate_public_ip_address = var.config.network_interfaces.associate_public_ip_address
        delete_on_termination = var.config.network_interfaces.delete_on_termination
        subnet_id = var.config.network_interfaces.subnet_id
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Environment = var.global.env
            Project = var.global.tags.Project
            Owner = var.glocal.tags.Owner
            Name = "${var.global.app}-${var.global.env}-${var.config.name}"
        }
    }

    tag_specifications {
        resource_type = "volume"
        tags = var.global.tags
    }
}

module "security_group" {
    source = "../vpc/security_group"
    global = var.global
    config = {
        name = var.config.name
        vpc_id = var.global.vpc.id

        ingress = [for ingress in var.config.security_group :
            merge(
                ingress,
                {
                    cidr_blocks = [data.aws_vpc.default.cidr_blocks]
                }
            )
        ]

        egress = {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

output "launch_template" {
    value = aws_launch_template.default 
}

output "security_group" {
    value = module.security_group.launch_template
}