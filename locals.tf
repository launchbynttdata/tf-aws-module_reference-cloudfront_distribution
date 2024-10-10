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

locals {

  cloudfront_record = var.dns_record != null ? {

    (var.dns_record.name) = {
      type = var.dns_record.type
      name = var.dns_record.name
      alias = {
        name                   = module.cloudfront_distribution.cloudfront_distribution_domain_name
        zone_id                = module.cloudfront_distribution.cloudfront_distribution_hosted_zone_id
        evaluate_target_health = false
      }
    }
  } : {}

  viewer_certificate = {
    acm_certificate_arn      = module.acm[0].acm_certificate_arn
    ssl_support_method       = var.viewer_certificate.ssl_support_method
    minimum_protocol_version = var.viewer_certificate.minimum_protocol_version
  }

  aliases = var.dns_record != null ? ["${var.dns_record.name}.${var.dns_zone_name}"] : []
}
