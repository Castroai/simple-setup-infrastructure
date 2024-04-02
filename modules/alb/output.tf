output "api_target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.api-tg.arn
}

output "client_target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.web-tg.arn
}


output "api_listener_arn" {
  description = "The ARN of the listener"
  value       = aws_lb_listener.api_https_listener.arn
}

output "client_listener_arn" {
  description = "The ARN of the listener"
  value       = aws_lb_listener.client_https_listener.arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.lb_sg.id

}
