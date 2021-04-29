variable "environment" {
}

variable "log_retention_days" {
  default = "30"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
}

variable "resource_group_name" {
  default = "rg-uks-ais-demo"
}

variable "la-receive-url" {

}