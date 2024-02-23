# Architecture

# Pre-Requisites
Pre-Requisites
1.	Terraform installed in your machine
2.	AWS CLI profile (To authenticate with AWS Cloud from Terraform. Better to use this approach rather than hardcoding the credentials directly in the file)

# Resources created
•	S3 bucket
•	CloudFront pointing to S3 bucket
•	HTTPS certificate in AWS Certificate Manager (Same R53 domain name)
•	R53 Alias record pointing to CloudFront

# Terraform.tfvars variables

# How to Execute
1.	Fill the terraform.tfvars
2.	Update the profile information in provider.tf 
(Leave the region to us-east-1 as the CloudFront always needs to be created in that region. It will serve the global users via the edge locations in all regions.
3.	Issue “terraform init”
4.	Issue “terraform plan”
5.	To create the resources “terraform apply -auto-approve”
6.	Leave 5-10 minutes after resource creation and access the domain name
7.	To destroy the resources “terraform destroy -auto-approve”

# Developer 
K.Janarthanan
