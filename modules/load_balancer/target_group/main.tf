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
            port = number 
            protocol = string
            target_type = string
    })
}

resource "aws_lb_target_group" "default" {
    name = var.config.name
    port = var.config.port
    protocol = var.config.protocol
    vpc_id = var.global.vpc.id
    target_type = var.config.target_type

}

output "object" {
    value = aws_lb_target_group.default
}