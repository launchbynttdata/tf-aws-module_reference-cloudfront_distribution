// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# Variables related to resource_name module

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "ecs"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

# Variables related to cloudfront_distribution module

variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "custom_error_response" {
  description = "One or more custom error response elements."
  type = list(object({
    error_caching_min_ttl = optional(number, null)
    error_code            = number
    response_code         = optional(number, null)
    response_page_path    = optional(string, null)
  }))
  default = []
}

variable "default_cache_behavior" {
  description = "Default cache behavior for this distribution."
  type = object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    cache_policy_id           = string
    compress                  = optional(bool, false)
    default_ttl               = optional(number, null)
    field_level_encryption_id = optional(string, null)
    lambda_function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    max_ttl                    = optional(number, null)
    min_ttl                    = optional(number, null)
    origin_request_policy_id   = optional(string, null)
    realtime_log_config_arn    = optional(string, null)
    response_headers_policy_id = optional(string, null)
    smooth_streaming           = optional(bool, null)
    target_origin_id           = string
    trusted_key_groups         = optional(list(string), [])
    trusted_signers            = optional(list(string), [])
    viewer_protocol_policy     = optional(string, "redirect-to-https")
  })
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return (e.g. `index.html`) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content. Defaults to `true`."
  type        = bool
  default     = true
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution. Will use the cloudfront_default_certificate unless `acm_certificate_arn` or `iam_certificate_id` are specified (pick one; do not specify both). For specifics on configuration of minimum protocol versions, see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#viewer-certificate-arguments."
  type = object({
    acm_certificate_arn      = optional(string, null)
    iam_certificate_id       = optional(string, null)
    minimum_protocol_version = optional(string, "TLSv1")
    ssl_support_method       = optional(string, "sni-only")
  })
  default = {
    acm_certificate_arn      = null
    iam_certificate_id       = null
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = null
  }
}

# Variables related to dns_zone module

variable "dns_zone_name" {
  description = <<EOT
    Name of the Route53 DNS Zone where custom DNS records will be created. Required if use_https_listeners=true. var.private_zone
    must also be specified if this variable is not empty.
  EOT
  type        = string
  default     = ""
}

variable "private_zone" {
  description = <<EOT
    Whether the dns_zone_name provided above is a private or public hosted zone. Required if dns_zone_name is not empty.
    private_zone=true means the hosted zone is private and false means it is public.
  EOT
  type        = bool
  default     = null
}

# Variables related to dns_record module

variable "dns_record" {
  description = "DNS record to be created in the DNS zone pointing to the cloudfront."
  type = object({
    type = string
    name = string
  })
  default = null
}

#variables related to s3_bucket module

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "(Optional, Forces new resource) The name of the bucket. If value is set to null, then this module will generate a name as per standard naming convention and assign it."
  type        = string
  default     = null
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "html_files" {
  description = "List of HTML files to upload"
  type        = list(string)
}
