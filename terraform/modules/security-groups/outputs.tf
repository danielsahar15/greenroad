output "eks_security_group_id" {
  value = aws_security_group.eks.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}