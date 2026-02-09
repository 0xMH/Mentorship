variable "cidr_block" {
    description = "Value of CIDR_Block for VPC"
    type = string
}

variable "map_public_ip_on_launch" {
  description = "instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = false
}

variable "public_subnet_cidrs" {
  type = list(string)

}

variable "azs" {
    description = "List of Avilability Zones where subnets will be created"
    type = list(string)
    default = []
}

variable "private_subnet_cidrs" {
  type = list(string)

}

variable "single_nat_gateway" {
    type = bool
    default = false  
}

variable "one_nat_gateway_per_az" {
    type = bool
    default = true
}

