app = {

      global = {
          app = ##
          env = ##

          vpc = {
              id = ##
          }

          tags = {
              Project = ##
              Owner = ##
              Environment = ##
          }
      }

    load_balancer = {
        alb = {
            name = ##
            internal = ##
            load_balancer_type = ##
            subnets = [##, ##]
            enable_deletion_protection = ##

            security_group = {
                name = ##
                description = ##

                ingress = [
                    {
                        from_port = ##
                        to_port = ##
                        protocol = ##
                    },
                    {
                        from_port = ##
                        to_port = ##
                        protocol = ##
                    }
                ]
            }
        }

        target_group = {
            name = ##
            port = ##
            protocol = ##
            target_type = ##
        }

        http_listener = {
            port = ##
            protocol = ##
            ssl_policy = ##
            certificate_arn = ##
            
            default_action = {
                type = ##
            }
        }

        https_listener = {
            port = ##
            protocol = ##
            ssl_policy = ##
            certificate_arn = ##
            
            default_action = {
                type = ##
            }
        }

        target_group_attachment = {
            port = ##
        }
    }

    mysql = {
        allocated_storage = ##
        engine = ##
        engine_version = ##
        instance_class = ##
        name = ##
        username = ##
        password = ##
        parameter_group_name = ##
        skip_final_snapshot = ##
        deletion_protection = ##
        availability_zone = ##

        security_group = {
            name = ##
            description = ##

            ingress = [
                {
                    from_port = ##
                    to_port = ##
                    protocol = ##
                }
            ]
        }
    }

    web_server = {
        ami = ##
        instance_type = ##
        subnet_id = ##
        Name = ##

        root_block_device = {
            volume_size = ##
            volume_type = ##
            delete_on_termination = ##
        }

        network_interface = {
            subnet_id = ##
            private_ip = ##

            security_group = {
                name = ##
                description = ##

                ingress = [
                    {
                        from_port = ##
                        to_port = ##
                        protocol = ##
                    }
                ]
            }
        }
    }

    app_server = {
        ami = ##
        instance_type = ##
        subnet_id = ##
        Name = ##

        root_block_device = {
            volume_size = ##
            volume_type = ##
            delete_on_termination = ##
        }

        network_interface = {
            subnet_id = ##
            private_ip = ##

            security_group = {
                name = ##
                description = ##

                ingress = [
                    {
                        from_port = ##
                        to_port = ##
                        protocol = ##
                    }
                ]
            }
        }
}}