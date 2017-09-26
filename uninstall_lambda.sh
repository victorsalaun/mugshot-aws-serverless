#!/usr/bin/env bash

TEMPLATE_FILE_NAME='mugshot-lambda.cfn.yml'
PACKAGE_FILE_NAME='mugshot-lambda-xfm.cfn.yml'
STACK_NAME='mugshot-lambda'
BUCKET_NAME_TEMPLATE="mug-shot-template-s3"
BUCKET_CODE="mug-shot-code-s3"

# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

# try to empty the bucket BUCKET_CODE
if aws s3 rb s3://${BUCKET_CODE}; then
    echo "Bucket s3://${BUCKET_CODE} emptied successfully"
else
    echo "Failed emptying bucket s3://${BUCKET_CODE}"
fi

# Try to remove the package
if aws cloudformation delete-stack --stack-name ${STACK_NAME}; then
    echo "Package ${STACK_NAME} removed successfully"
else
    echo "Failed removing package ${STACK_NAME}"
fi