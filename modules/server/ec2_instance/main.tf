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
        # data = object({
        #     filter = list(object({
        #         name = string
        #         values = list(string)
        #     }))
        #     owners = list(string)
        # })
        ami = string
        instance_type = string
        subnet_id = string
        Name = string

        root_block_device = object({
            volume_size = number
            volume_type = string
            delete_on_termination = bool
        })

        network_interface = object({
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
    })

}

# data "aws_ami" "default" {
#     most_recent = true
#     owners = var.config.data.owners

#     dynamic filter {
#         for_each = var.config.data.filter
#         content {
#             name = filter.name
#             values = filter.values
#         }
#     }
# }

resource "aws_instance" "default" {
    # ami = data.aws_ami.default.id
    ami = var.config.ami
    instance_type = var.config.instance_type
    subnet_id = var.config.subnet_id

    tags = var.global.tags


    root_block_device {
        volume_size = var.config.root_block_device.volume_size
        volume_type = var.config.root_block_device.volume_type
        delete_on_termination = var.config.root_block_device.delete_on_termination
    }

    network_interface {
        network_interface_id = module.network_interface.object.id
        device_index = 0
    }
}

module "network_interface" {
    source = "../network_interface"
    global = var.global
    config = var.config.network_interface
}

output "object" {
    value = aws_instance.default
}