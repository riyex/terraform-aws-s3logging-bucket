variable "bucket_name" {
  default     = null
  description = "Name to apply to bucket (use `bucket_name` or `bucket_suffix`)"
  type        = string
}

variable "bucket_suffix" {
  default     = "default"
  description = "Suffix to apply to the bucket (use `bucket_name` or `bucket_suffix`). When using `bucket_suffix`, the bucket name will be `[account_id]-[region]-s3logging-[bucket_suffix]."
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "KMS key to encrypt bucket with."
  type        = string
}

variable "lifecycle_rules" {
  description = "lifecycle rules to apply to the bucket"

  default = [
    {
      id                            = "expire-noncurrent-objects-after-ninety-days"
      noncurrent_version_expiration = 90
    },
    {
      id = "transition-to-IA-after-30-days"
      transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
      }]
    },
    {
      id         = "delete-after-seven-years"
      expiration = 2557
    },
  ]

  type = list(object(
    {
      id                            = string
      enabled                       = optional(bool, true)
      expiration                    = optional(number)
      prefix                        = optional(number)
      noncurrent_version_expiration = optional(number)
      transition = optional(list(object({
        days          = number
        storage_class = string
      })))
  }))
}

variable "tags" {
  default     = {}
  description = "Tags to add to supported resources"
  type        = map(string)
}

variable "versioning_enabled" {
  default     = true
  description = "Whether or not to use versioning on the bucket. This can be useful for audit purposes since objects in a logging bucket should not be updated."
  type        = bool
}
