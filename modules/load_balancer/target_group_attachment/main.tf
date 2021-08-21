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
        target_group_arn = string
        target_id = string
        port = number
    })
}

resource "aws_lb_target_group_attachment" "default" {
    target_group_arn = var.config.target_group_arn
    target_id = var.config.target_id
    port = var.config.port
}

output "object" {
    value = aws_lb_target_group_attachment.default
}
