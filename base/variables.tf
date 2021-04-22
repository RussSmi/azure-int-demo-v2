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

variable "pwdsecrets" {
  type    = list(any)
  default = ["jumpuser"]
}

variable "keysecrets" {
  type    = list(any)
  default = ["monitor-key"]
}

variable "object-ids" {
  type    = list(any)
  default = ["96b43a71-7601-4719-9235-eff0b530b157", "2933b5e7-efa0-49d3-9963-0a8a33ec2da2"] #Put any object ids that need key vault access here
}

# The following variables must  be set each time
variable "environment" {
}


