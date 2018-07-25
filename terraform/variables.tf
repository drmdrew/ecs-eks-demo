
variable "s3-bucket-region" {
    type = "string"
    default = "us-east-1"
}

variable "environment" {
    type = "string"
    default = "dev"
}

variable "region" {
    type = "string"
    default = "us-east-1"
}

variable "vpc_cidr" {
    type = "string"
    default = "10.66.0.0/16"
}