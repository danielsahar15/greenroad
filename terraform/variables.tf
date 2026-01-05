
variable "region" {}
variable "cluster_name" {}
variable "vpc_cidr" {}
variable "ecr_repository_name" {}
variable "ingress_host" { default = "" }
variable "replicas" { default = 1 }
variable "cpu_limit" { default = "200m" }
variable "memory_limit" { default = "256Mi" }
variable "alarm_threshold" { default = 80 }
