#!/usr/bin/env bash

STATIC_BUCKET_NAME="mug-shot-static-s3"

# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

aws s3 sync ./static/  s3://${STATIC_BUCKET_NAME}/