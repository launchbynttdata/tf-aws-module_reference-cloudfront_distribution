# with_cake

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | 5.72.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_s3_bucket"></a> [aws\_s3\_bucket](#module\_aws\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.14.0 |
| <a name="module_cloudfront_distribution"></a> [cloudfront\_distribution](#module\_cloudfront\_distribution) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_policy.website_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_object.html_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"ecs"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution. | `string` | `null` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements. | <pre>list(object({<br>    error_caching_min_ttl = optional(number, null)<br>    error_code            = number<br>    response_code         = optional(number, null)<br>    response_page_path    = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Default cache behavior for this distribution. | <pre>object({<br>    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br>    cache_policy_id           = string<br>    compress                  = optional(bool, false)<br>    default_ttl               = optional(number, null)<br>    field_level_encryption_id = optional(string, null)<br>    lambda_function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })), [])<br>    function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })), [])<br>    max_ttl                    = optional(number, null)<br>    min_ttl                    = optional(number, null)<br>    origin_request_policy_id   = optional(string, null)<br>    realtime_log_config_arn    = optional(string, null)<br>    response_headers_policy_id = optional(string, null)<br>    smooth_streaming           = optional(bool, null)<br>    target_origin_id           = string<br>    trusted_key_groups         = optional(list(string), [])<br>    trusted_signers            = optional(list(string), [])<br>    viewer_protocol_policy     = optional(string, "redirect-to-https")<br>  })</pre> | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Object that you want CloudFront to return (e.g. `index.html`) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution. Will use the cloudfront\_default\_certificate unless `acm_certificate_arn` or `iam_certificate_id` are specified (pick one; do not specify both). For specifics on configuration of minimum protocol versions, see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#viewer-certificate-arguments. | <pre>object({<br>    acm_certificate_arn      = optional(string, null)<br>    iam_certificate_id       = optional(string, null)<br>    minimum_protocol_version = optional(string, "TLSv1")<br>    ssl_support_method       = optional(string, "sni-only")<br>  })</pre> | <pre>{<br>  "acm_certificate_arn": null,<br>  "iam_certificate_id": null,<br>  "minimum_protocol_version": "TLSv1",<br>  "ssl_support_method": null<br>}</pre> | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Name of the Route53 DNS Zone where custom DNS records will be created. Required if use\_https\_listeners=true. var.private\_zone<br>    must also be specified if this variable is not empty. | `string` | `""` | no |
| <a name="input_private_zone"></a> [private\_zone](#input\_private\_zone) | Whether the dns\_zone\_name provided above is a private or public hosted zone. Required if dns\_zone\_name is not empty.<br>    private\_zone=true means the hosted zone is private and false means it is public. | `bool` | `null` | no |
| <a name="input_dns_record"></a> [dns\_record](#input\_dns\_record) | DNS record to be created in the DNS zone pointing to the cloudfront. | <pre>object({<br>    type = string<br>    name = string<br>  })</pre> | `null` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | (Optional, Forces new resource) The name of the bucket. If value is set to null, then this module will generate a name as per standard naming convention and assign it. | `string` | `null` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_html_files"></a> [html\_files](#input\_html\_files) | List of HTML files to upload | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The deployment status of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The Domain Name of the CloudFront Distribution. |
| <a name="output_record_fqdns"></a> [record\_fqdns](#output\_record\_fqdns) | FQDNs built using the zone domain and name. |
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the ACM Certificate. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The Hosted Zone ID of the CloudFront Distribution. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
