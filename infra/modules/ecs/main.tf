resource "aws_security_group" "svc_sg" {
  name        = "${var.project_name}-svc-sg"
  description = "ECS tasks allow ALB ingress"
  vpc_id      = var.vpc_id

  ingress {
    description = "from ALB"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    security_groups = [var.alb_security_group_id]
  }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    }

  tags = { 
    Name = "${var.project_name}-svc-sg" 
    }
}

resource "aws_iam_role" "task_exec" {
  name               = "${var.project_name}-task-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "exec_attach" {
  name       = "${var.project_name}-exec-attach"
  roles      = [aws_iam_role.task_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${var.project_name}-task-role"
  assume_role_policy = aws_iam_role.task_exec.assume_role_policy
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.container_cpu)
  memory                   = tostring(var.container_memory)
  execution_role_arn       = aws_iam_role.task_exec.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions    = jsonencode([
    {
      name      = "app",
      image     = "${var.ecr_repository_url}:${var.image_tag}",
      essential = true,
      portMappings = [{ 
        containerPort = var.container_port 
        hostPort = var.container_port
        }]
      environment = [
        { name = "DDB_TABLE", value = var.dynamodb_table_name }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-svc"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.svc_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [var.alb_https_listener_arn]
}
