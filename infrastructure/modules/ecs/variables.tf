variable "cluster_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ecs_service_sg_ingress_from_alb" {
  type = string
}
variable "container_port" {
  type = number
}
variable "desired_count" {
  type = number
}
variable "image" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "dynamodb_table_name" {
  type = string
}