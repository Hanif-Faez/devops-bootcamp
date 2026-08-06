output "rackula_url" {
  description = "Public URL to access Rackula"
  value       = "http://${module.my_server_rackula.public_ip}:8080"
}

output "ssm_command" {
  description = "SSM Session Manager command to connect to the Rackula server"
  value       = "aws ssm start-session --target ${module.my_server_rackula.id}"
}
