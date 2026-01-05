variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group ASG name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "alarm_threshold" {
  description = "Threshold for CloudWatch alarms"
  type        = number
  default     = 80
}