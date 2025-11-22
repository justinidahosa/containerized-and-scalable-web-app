variable "domain_prefix" {
  type = string
}
variable "callback_urls" {
  type = list(string)
}
variable "logout_urls" {
  type = list(string)
}
variable "region" {
  type = string
}