variable "location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  default = "rg-uks-ais-demo"
}

variable "key_vault_name" {
  default = "kvaisdemo"
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
  default = ["7f36b222-2faa-490a-85d2-77f2ee8000a3", "d74352c2-e9d9-4087-9baf-be409def0951"] #Put any object ids that need key vault access here
}

# The following variables must  be set each time
variable "environment" {
}

variable "apim_policies_path" {
  type    = string
  default = "./apim_policies/"
}



