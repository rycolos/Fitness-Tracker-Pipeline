#outputs.tf
output "security_group_id" {
  value       = aws_security_group.rds_sg.id
}
output "db_instance_endpoint" {
  value       = aws_db_instance.fitness-db.endpoint
}
output "ec2_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.fitness-ec2[0].public_ip
}