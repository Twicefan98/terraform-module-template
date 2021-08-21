terraform {
}

module "web_ec2_instance" {
    source = "./modules/server/ec2_instance"
    global = var.app.global
    config = var.app.web_server
}

module "web_ec2_instance" {
    source = "./modules/server/ec2_instance"
    global = var.app.global
    config = var.app.web_server
}

module "app_ec2_instance" {
    source = "./modules/server/ec2_instance"
    global = var.app.global
    config = var.app.app_server
}

module "app_ec2_instance" {
    source = "./modules/server/ec2_instance"
    global = var.app.global
    config = var.app.app_server
}

module "security_group" {
    source = "./modules/vpc"
}

module "load_balancer" {
    source = "./modules/load_balancer/alb"
    global = var.app.global
    config = var.app.load_balancer.alb
}

module "http_listener" {
    source = "./modules/load_balancer/listener"
    global = var.app.global
    config = {
        load_balancer_arn = module.load_balancer.object.id
        port = var.app.load_balancer.http_listener.port
        protocol = var.app.load_balancer.http_listener.protocol
        ssl_policy = var.app.load_balancer.http_listener.ssl_policy
        certificate_arn = var.app.load_balancer.http_listener.certificate_arn
        
        default_action = {
            type = var.app.load_balancer.http_listener.default_action.type
            target_group_arn = module.target_group.object.id
        }
    }
}

module "https_listener" {
    source = "./modules/load_balancer/listener"
    global = var.app.global
    config = {
        load_balancer_arn = module.load_balancer.object.id
        port = var.app.load_balancer.https_listener.port
        protocol = var.app.load_balancer.https_listener.protocol
        ssl_policy = var.app.load_balancer.https_listener.ssl_policy
        certificate_arn = var.app.load_balancer.https_listener.certificate_arn
        
        default_action = {
            type = var.app.load_balancer.https_listener.default_action.type
            target_group_arn = module.target_group.object.id
        }
    }
}

module "target_group" {
    source = "./modules/load_balancer/target_group"
    global = var.app.global
    config = var.app.load_balancer.target_group
}

module "target_group_attachment" {
    source = "./modules/load_balancer/target_group_attachment"
    global = var.app.global
    config = {
        target_group_arn = module.target_group.object.id
        target_id = module.web_ec2_instance.object.id
        port = var.app.load_balancer.target_group_attachment.port
    }
}