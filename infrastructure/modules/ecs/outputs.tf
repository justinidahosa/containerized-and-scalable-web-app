output "service_name" {
  value = aws_ecs_service.svc.name
}
output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}
output "service_arn" {
  value = aws_ecs_service.svc.arn
}
output "task_role_arn" {
  value = aws_iam_role.task.arn
}
output "exec_role_arn" {
  value = aws_iam_role.exec.arn
}
