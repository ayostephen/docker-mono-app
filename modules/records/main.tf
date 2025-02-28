# Route53 Record for Nexus
resource "aws_route53_record" "nexus_record" {
  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "nexus.${var.domain-name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.nexus-server.public_ip]
}
