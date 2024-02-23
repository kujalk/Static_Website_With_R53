resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}


resource "aws_s3_bucket_acl" "example" {
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "public-block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

// Allow bucket access from Cloudfront only
resource "aws_s3_bucket_policy" "prod_website" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": 
    [ 
        {
            "Sid": "cloud-front-read-access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.cf.iam_arn}"
                },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        }
    ]
}
POLICY
}

// Uploading the webpage
resource "aws_s3_object" "webpage" {
  for_each     = fileset(var.web_folder, "*")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${var.web_folder}${each.value}"
  etag         = filemd5("${var.web_folder}${each.value}")
  content_type = "text/html"
}