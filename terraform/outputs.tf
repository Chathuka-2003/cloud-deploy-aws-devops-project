output "vpc_id" {
  description = "CloudDeploy VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "CloudDeploy public subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "CloudDeploy EC2 security group ID"
  value       = aws_security_group.ec2.id
}

output "ec2_instance_id" {
  description = "CloudDeploy EC2 instance ID"
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "CloudDeploy EC2 public IP"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "CloudDeploy EC2 public DNS"
  value       = aws_instance.app.public_dns
}

output "backend_ecr_url" {
  description = "CloudDeploy backend ECR repository URL"
  value       = data.aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_url" {
  description = "CloudDeploy frontend ECR repository URL"
  value       = data.aws_ecr_repository.frontend.repository_url
}