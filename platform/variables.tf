variable "location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  default = "rg-uks-ais-demo"
}

variable "key_vault_name" {
  default = "kvaisshared"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default = {
    Application = "Azure Integration Services Demo", Environment = "nonprod", Keep = "Yes"
  }
}

variable "keysecrets" {
  type    = list(any)
  default = ["monitor-key"]
}

# The following variables must  be set each time
variable "environment" {
}

variable "log_analytics_workspace_id" {

}

variable "la-receive-url" {

}


