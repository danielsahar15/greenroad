
# VPC Module
module "vpc" {
  source = "./modules/vpc"
  cidr   = var.vpc_cidr
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

# IAM Module for roles and policies
module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
}

# EKS Module for cluster and node group
module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  subnet_ids       = module.vpc.private_subnets
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  region           = var.region
}

# CloudWatch Module for monitoring
module "cloudwatch" {
  source          = "./modules/cloudwatch"
  cluster_name    = module.eks.cluster_name
  node_group_name = module.eks.node_group_name
  region          = var.region
  alarm_threshold = var.alarm_threshold
}

# ECR Module for container registry
module "ecr" {
  source = "./modules/ecr"
  name   = var.ecr_repository_name
}

# ALB Module for load balancer
module "alb" {
  source             = "./modules/alb"
  public_subnet_ids  = module.vpc.public_subnets
  security_group_id  = module.security_groups.alb_security_group_id
  vpc_id             = module.vpc.vpc_id
}

# Fluent Bit Helm release for log shipping
resource "helm_release" "fluent_bit" {
  name       = "aws-for-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  namespace  = "amazon-cloudwatch"
  create_namespace = true

  set = [
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "fluent-bit"
    },
    {
      name  = "serviceAccount.annotations.eks.amazonaws.com/role-arn"
      value = module.eks.fluent_bit_role_arn
    },
    {
      name  = "cloudWatchLogs.region"
      value = var.region
    },
    {
      name  = "cloudWatchLogs.logGroupName"
      value = "/aws/containerinsights/${module.eks.cluster_name}/application"
    }
  ]
}
