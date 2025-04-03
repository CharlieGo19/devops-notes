variable "denied_cidrs" {
  /*
    10.10.0.0/24 Reserved for other learning.
  */
  description = "Forbidden VPC CIDR Ranges."
  type        = list(string)
  default     = ["10.10.0.0/24"]
  # TODO: Implement checks against this.
}

variable "tags_prefix" {
  description = "Prefix for tags, e.g. 'production'"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for the test VPC, testing 3 tiers on 3 AZ's."
  type        = string

  validation {
    condition     = can(regex("/21$", var.vpc_cidr))
    error_message = "The VPC CIDR block must be a /21 network (e.g. 10.0.0.0/21) and not overlap with: ${join(",", var.denied_cidrs)}"
  }
}