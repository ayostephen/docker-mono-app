output "jenkins_private_ip" {
  description = "Private IP of the jenkins Slaves"
  value       = aws_instance.jenkins.private_ip[count.index]   # Another option is to duplicate this block and remove the count.index
}

output "jenkins_instance_id" {
  description = "ID of the jenkins host instance"
  value       = aws_instance.jenkins.id[count.index]         # Another option is to duplicate this block and remove the count.index
}

output "jenkins_lb_dns_name" {
  description = " DNS name of the jenkins load balancer"
  value       = aws_elb.jenkins_lb.dns_name[count.index]    # Another option is to duplicate this block and remove the count.index
}

output "jenkins_lb_zone_id" {
  description = "Zone ID of the jenkins load balancer"
  value       = aws_elb.jenkins_lb.zone_id
}