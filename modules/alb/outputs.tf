//=======================================================================================================\\
//                                           ALB Outputs                                                 \\
//=======================================================================================================\\

output "alb_id" {
  description = "The ID of the ALB"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  value       = aws_lb.alb.zone_id
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "alb_security_group_id" {
  description = "The Security Group ID attached to the ALB"
  value       = aws_security_group.alb_sg.id
}

output "http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}
