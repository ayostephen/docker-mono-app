output "nexus_server_public_ip" {
  value = aws_instance.nexus-server.public_ip
}

output "nexus_lb_dns_name" {
  description = "DNS of the nexus host"
  value       = aws_elb.nexus-server-elb.dns_name
}

output "nexus_lb_zone_id" {
  description = "Zone ID of the nexus load balancer"
  value       = aws_elb.nexus-server-elb.zone_id
}