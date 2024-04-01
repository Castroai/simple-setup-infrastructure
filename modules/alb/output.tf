output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}

output "listener_arn" {
  description = "The ARN of the listener"
  value       = aws_lb_listener.listener.arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.lb_sg.id

}
