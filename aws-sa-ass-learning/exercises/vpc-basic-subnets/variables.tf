variable "tags_prefix" {
  description = "Prefix for tags, e.g. 'production'"
  type        = string
}

variable "user_defined_ipv4_cidr" {
  description = "CIDR requested by the user."
  type        = string
}