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
        availability_zones = list(string)
        desired_capacity = string
        max_size = string
        min_size = string

        launch_template = object({
            id = string
            version = string
        })
    })
}

resource "aws_autoscaling_group" "default" {
  availability_zones = var.config.availability_zones
  desired_capacity   = var.config.desired_capacity
  max_size           = var.config.max_size
  min_size           = var.config.min_size

  launch_template {
    id      = var.config.launch_template.id
    version = var.config.launch_template.version
  }
}

output "object" {
    value = aws_autoscaling_group.default
}