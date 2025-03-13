output "sonarqube_public_ip" {
  description = "Public IP of the sonarqube host"
  value       = aws_instance.sonarqube_instance.public_ip
}

output "sonarqube_instance_id" {
  description = "ID of the sonarqube host instance"
  value       = aws_instance.sonarqube_instance.id
}

output "sonarqube_lb_dns_name" {
  description = "DNS of the sonarqube host"
  value       = aws_elb.elb-sonar.dns_name
}

output "sonarqube_lb_zone_id" {
  description = "Zone ID of the sonarqube load balancer"
  value       = aws_elb.elb-sonar.zone_id
}