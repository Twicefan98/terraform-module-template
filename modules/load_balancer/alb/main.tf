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
        internal = bool
        load_balancer_type = string
        subnets = list(string)
        enable_deletion_protection = bool

        security_group = object({
            name = string
            description = string

            ingress = list(object({
                from_port = number
                to_port = number
                protocol = string
            }))
        })

        # target_group = object({
        #     name = string
        #     port = number 
        #     protocol = string
        #     target_type = string
        # })

        # http_listener = object({
        #     load_balancer_arn = string
        #     port = string
        #     protocol = string
            
        #     default_action = object({
        #         type = string
        #     })
        # })

        # https_listener = object({
        #     load_balancer_arn = string
        #     port = string
        #     protocol = string
        #     ssl_policy = string
        #     certificate_arn = string
            
        #     default_action = object({
        #         type = string
        #     })
        # })
    })
}

data "aws_vpc" "default" {
    id = var.global.vpc.id
}

resource "aws_lb" "default" {
    name = var.config.name
    internal = var.config.internal
    load_balancer_type = var.config.load_balancer_type
    subnets = var.config.subnets
    enable_deletion_protection = var.config.enable_deletion_protection

    security_groups = [module.security_group.object.id]
}


module "security_group" {
    source = "../../vpc/security_group"
    global = var.global
    config = {
        name = var.config.name
        vpc_id = var.global.vpc.id

        ingress = [for ingress in var.config.security_group.ingress :
            merge(
                ingress,
                {
                    cidr_blocks = [data.aws_vpc.default.cidr_block]
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
  value = aws_lb.default
}