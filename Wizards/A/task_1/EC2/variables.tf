variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "region" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "security_group_id" {
    type = string
}

variable "docker_image_url" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "key_name" {
    type = string
}

