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

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront Distribution."
  value       = module.cloudfront_distribution.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront Distribution."
  value       = module.cloudfront_distribution.cloudfront_distribution_arn
}

output "cloudfront_distribution_status" {
  description = "The deployment status of the CloudFront Distribution."
  value       = module.cloudfront_distribution.cloudfront_distribution_status
}

output "cloudfront_distribution_domain_name" {
  description = "The Domain Name of the CloudFront Distribution."
  value       = module.cloudfront_distribution.cloudfront_distribution_domain_name
}

output "record_fqdns" {
  description = "FQDNs built using the zone domain and name."
  value       = try(module.cloudfront_distribution.record_fqdns, "")
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM Certificate."
  value       = try(module.cloudfront_distribution.acm_certificate_arn, "")
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The Hosted Zone ID of the CloudFront Distribution."
  value       = module.cloudfront_distribution.cloudfront_distribution_hosted_zone_id
}
