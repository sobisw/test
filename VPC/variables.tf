variable "aws_region" {
  description = "AWS Region"
  default ="ap-southeast-2"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  default = ""
}

variable "availability_zones" {
  default = []
  description = "Availability Zones for given AWS Region"
}

variable "vpc_cidr_block" {
  description = "Main VPC CIDR Block"
  default = ""
}

variable "public_subnet_cidr_block" {
  default = []
  description = "Public Subnet CIDR Block"
}

variable "private_subnet_cidr_block" {
  default = []
  description = "Private Subnet CIDR Block"
}
