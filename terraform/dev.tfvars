
# AWS Region for all resources
region = "us-east-1"

# EKS Cluster name
cluster_name = "road-safety-dev"

# VPC CIDR block
vpc_cidr = "10.0.0.0/16"

# ECR Repository name for the app image
ecr_repository_name = "road-safety"

# Ingress host for the app (ALB domain)
ingress_host = "dev.road-safety.com"

# Number of app replicas
replicas = 1

# CPU limit for app pods
cpu_limit = "200m"

# Memory limit for app pods
memory_limit = "256Mi"

# Threshold for CloudWatch alarms (%)
alarm_threshold = 80
