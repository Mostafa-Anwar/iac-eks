output "sub-pub1" {
  value       = aws_subnet.public-subnets[0].id
  description = "The ID of the public subnet in az1"
}

output "sub-pub2" {
  value       = aws_subnet.public-subnets[1].id
  description = "The ID of the public subnet in az2"
}

output "sg-eks-access" {
  value       = aws_security_group.sg_eks_access.id
  description = "The ID of the access security group"
}