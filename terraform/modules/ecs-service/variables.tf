variable "internal" {
    type = "string"
    default = "true"
}

variable "vpc_id" {
    type = "string"
}

variable "vpc_cidr" {
    type = "string"
}

variable "subnet_ids" {
    type = "list"
}

variable "alb_subnet_ids" {
    type = "list"
}
variable "cluster_id" {
    type = "string"
}

variable "container_image" {
    type = "string"
}

variable "container_name" {
    type = "string"
}

variable "host_port" {
    type = "string"
}

variable "container_port" {
    type = "string"
}

variable "container_memory" {
    type = "string"
    default = "512"
}

variable "container_cpu" {
    type = "string"
    default = "256"
}

variable "container_command" {
    type = "list"
    default = []
}

variable "log_group_name" {
    type = "string"
}

variable "log_group_region" {
    type = "string"
}

variable "log_group_prefix" {
    type = "string"
}

variable "network_mode" {
    type = "string"
    default = "awsvpc"
}

