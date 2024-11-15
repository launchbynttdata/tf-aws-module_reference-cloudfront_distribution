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


# This module generates the resource-name of resources based on resource_type, logical_product_family, logical_product_service, env etc.
module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
}

#This module creates the Cloudfront distribution with the required configurations

module "cloudfront_distribution" {

  source  = "terraform.registry.launch.nttdata.com/module_primitive/cloudfront_distribution/aws"
  version = "~> 1.0"

  enabled                         = var.enabled
  aliases                         = local.aliases
  comment                         = var.comment
  continuous_deployment_policy_id = var.continuous_deployment_policy_id
  default_root_object             = var.default_root_object
  is_ipv6_enabled                 = var.is_ipv6_enabled
  staging                         = var.staging
  web_acl_id                      = var.web_acl_id
  retain_on_delete                = var.retain_on_delete
  wait_for_deployment             = var.wait_for_deployment
  tags                            = var.tags
  http_version                    = var.http_version
  default_cache_behavior          = var.default_cache_behavior
  custom_error_response           = var.custom_error_response
  logging_config                  = var.logging_config
  ordered_cache_behavior          = var.ordered_cache_behavior
  origin                          = var.origin
  geo_restrictions_type           = var.geo_restrictions_type
  geo_restrictions_locations      = var.geo_restrictions_locations
  viewer_certificate              = local.viewer_certificate

  depends_on = [module.acm]
}

# DNS Zone where the records for the Cloudfront will be created
data "aws_route53_zone" "dns_zone" {

  name         = var.dns_zone_name
  private_zone = var.private_zone
}

# DNS Record for the Cloudfront Distribution

module "aws_dns_record" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/dns_record/aws"
  version = "~> 1.0"

  count   = var.dns_record != null ? 1 : 0
  zone_id = data.aws_route53_zone.dns_zone.zone_id

  records = local.cloudfront_record

  depends_on = [module.acm]

}

# ACM Certificate for the Cloudfront Distribution.

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3.2"

  count       = var.dns_record != null ? 1 : 0
  domain_name = "${var.dns_record.name}.${data.aws_route53_zone.dns_zone.name}"
  zone_id     = data.aws_route53_zone.dns_zone.zone_id
}
