variable "name" {
    type = string
}

variable "internal" {
    type = bool
    default = false
}

variable "load_balancer_type" {
    type = string
    default = "application"
}

variable "security_groups" {
    type = list(string)
}

variable "subnets" {
    type = list(string)
}

variable "target_port" {
    type = number
    default = 80
}

variable "listener_port" {
    type = number
    default = 80
}

variable "protocol" {
    type = string
    default = "HTTP"
}

variable "target_instance" {
    type = string
    default = "instance"
}

variable "vpc_id" {
    type = string
}

variable "target_ids" {
    type = list(string)
}