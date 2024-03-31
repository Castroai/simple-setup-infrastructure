#!/bin/bash

# Set the S3 bucket name
bucket_name="example-appspec-bucket"

# Get the current directory
current_dir=$(dirname "$0")

# Upload the appspec.yaml file to the S3 bucket
aws s3 cp "$current_dir/appspec.yaml" "s3://$bucket_name/"
