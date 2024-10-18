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

// This module create s3 bucket with the required configurations and policies for hosting a static website

module "aws_s3_bucket" {

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.0"
  providers = {
    aws = aws.global
  }

  bucket        = var.bucket_name
  force_destroy = true

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = local.tags
}

resource "aws_s3_object" "html_files" {
  provider = aws.global

  for_each     = toset(var.html_files)
  bucket       = module.aws_s3_bucket.s3_bucket_id
  key          = each.value
  source       = each.value
  content_type = "text/html"
  etag         = filemd5(each.value)
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket   = module.aws_s3_bucket.s3_bucket_id
  provider = aws.global

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = ["${module.aws_s3_bucket.s3_bucket_arn}/*",
        module.aws_s3_bucket.s3_bucket_arn]
      }
    ]
  })
}

#This module creates the Cloudfront distribution with the required configurations and integrates with the s3 bucket, acm certificate and route53.

module "cloudfront_distribution" {

  source = "../.."

  providers = {
    aws = aws.global
  }

  enabled                 = var.enabled
  default_root_object     = var.default_root_object
  default_cache_behavior  = var.default_cache_behavior
  custom_error_response   = var.custom_error_response
  private_zone            = var.private_zone
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  origin                  = local.origin
  viewer_certificate      = var.viewer_certificate
  environment             = var.environment
  comment                 = var.comment
  dns_zone_name           = var.dns_zone_name
  dns_record              = var.dns_record
  tags                    = local.tags

}
