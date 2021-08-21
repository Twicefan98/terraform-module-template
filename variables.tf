variable "app" {
  type = object({
      global = object({
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

    load_balancer = object({
        alb = object({
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
        })

        target_group = object({
            name = string
            port = number 
            protocol = string
            target_type = string
        })

        http_listener = object({
            port = string
            protocol = string
            ssl_policy = string
            certificate_arn = string
            
            default_action = object({
                type = string
            })
        })

        https_listener = object({
            port = string
            protocol = string
            ssl_policy = string
            certificate_arn = string
            
            default_action = object({
                type = string
            })
        })

        target_group_attachment = object({
            port = number
        })
    })

    mysql = object({
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

    web_server = object({
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

    app_server = object({

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
  })
}