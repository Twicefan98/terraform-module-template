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

        ingress = set(object({
            from_port = number
            to_port = number
            protocol = string
            
        }))
    })
}

resource "aws_security_group" "default" {
    name = var.config.name
    
    dynamic "ingress" {
        iterator = ingress
        for_each = var.config.ingress
        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "object" {
    value = aws_security_group.default
}