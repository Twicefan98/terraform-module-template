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
            load_balancer_arn = string
            port = string
            protocol = string
            ssl_policy = string
            certificate_arn = string
            
            default_action = object({
                type = string
                target_group_arn = string
            })
        })
}

resource "aws_lb_listener" "default" {
    load_balancer_arn = var.config.load_balancer_arn
    port = var.config.port
    protocol = var.config.protocol
    ssl_policy = var.config.ssl_policy
    certificate_arn = var.config.certificate_arn
    
    default_action {
        type = var.config.default_action.type
        target_group_arn = var.config.default_action.target_group_arn
    }
}

output "object" {
    value = aws_lb_listener.default
}