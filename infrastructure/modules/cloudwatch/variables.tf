variable "sns_email" {
  type    = string
  default = ""
}
variable "ecs_cluster_name" {
  type = string
}
variable "ecs_service_name" {
  type = string
}
variable "alb_arn_suffix" {
  type = string
}
variable "api_id" {
  type = string
}