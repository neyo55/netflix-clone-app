

# Output for Netflix app instance
output "netflix_instance_public_ip" {
  value = aws_instance.netflix_app_instance.public_ip
}
output "netflix_instance_public_dns" {
  value = aws_instance.netflix_app_instance.public_dns
}

# Output for Monitoring app instance
output "monitoring_instance_public_ip" {
  value = aws_instance.monitoring_app_instance.public_ip
}
output "monitoring_instance_public_dns" {
  value = aws_instance.monitoring_app_instance.public_dns
}
