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

// tfvars for resource map

logical_product_family  = "launch"
logical_product_service = "frontend"

// tfvars for s3 bucket

bucket_name = "launch-static-webhosting"
html_files = [
  "index.html",
  "error.html" # Add all the HTML files you want to upload
]
block_public_acls       = false
block_public_policy     = false
ignore_public_acls      = false
restrict_public_buckets = false

//tfvars for cloudfront

enabled = true

default_root_object = "index.html"

viewer_certificate = {
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1"
}

default_cache_behavior = {
  target_origin_id       = "origin1"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  cached_methods         = ["GET", "HEAD"]
  cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}

custom_error_response = [{
  error_code         = "404"
  response_code      = "200"
  response_page_path = "/error.html"
}]

// data source for dns_zone

dns_zone_name = "sandbox.launch.nttdata.com"
private_zone  = false

//dns record tfvars

dns_record = {
  name = "static.hosting"
  type = "A"
}
