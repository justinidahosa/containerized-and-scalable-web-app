output "cluster_name"      { 
    value = aws_ecs_cluster.ecs_cluster.name 
}
output "service_name"      { 
    value = aws_ecs_service.ecs_service.name 
}
output "task_definition"   { 
    value = aws_ecs_task_definition.ecs_task_def.arn 
}
output "service_sg_id"     { 
    value = aws_security_group.svc_sg.id 
}
