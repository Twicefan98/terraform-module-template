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
        subnet_id = string
        private_ip = string

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

resource "aws_network_interface" "default" {
    subnet_id = var.config.subnet_id
    private_ip = var.config.private_ip
    security_groups = [module.security_group.object.id]
}

module "security_group" {
    source = "../../vpc/security_group"
    global = var.global
    config = var.config.security_group
}

output "object" {
    value = aws_network_interface.default
}