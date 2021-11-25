output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC."
}

output "public_subnets_ids" {
  value       = aws_subnet.public_subnets.*.id
  description = "List with the IDs of the public subnets."
}

output "private_subnets_ids" {
  value       = aws_subnet.private_subnets.*.id
  description = "List with the IDs of the private subnets."
}

output "mwaa_environment_arn" {
  value       = aws_mwaa_environment.mwaa_environment.arn
  description = "ARN of MWAA environment."
}