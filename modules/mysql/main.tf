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
        allocated_storage = number
        engine = string
        engine_version = string
        instance_class = string
        name = string
        username = string
        password = string
        parameter_group_name = string
        skip_final_snapshot = bool
        deletion_protection = bool
        availability_zone = string

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

resource "aws_db_instance" "default" {
    allocated_storage = var.config.allocated_storage
    engine = var.config.engine
    engine_version = var.config.engine_version
    instance_class = var.config.instance_class
    name = var.config.name
    username = var.config.username
    password = var.config.password
    parameter_group_name = var.config.parameter_group_name
    skip_final_snapshot = var.config.skip_final_snapshot
    deletion_protection = var.config.deletion_protection
    availability_zone = var.config.availability_zone
    vpc_security_group_ids = var.config.vpc_security_group_ids
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

output "object" {
    value = aws_db_instance.default
}