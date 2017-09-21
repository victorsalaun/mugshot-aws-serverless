#!/usr/bin/env bash

TEMPLATE_FILE_NAME='mugshot-cognito.cfn.yml'
PACKAGE_FILE_NAME='mugsho-tcognito-xfm.cfn.yml'
STACK_NAME='mugshot-cognito'
BUCKET_NAME_TEMPLATE="mug-shot-template-s3"


# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

# Try to remove the package
if aws cloudformation delete-stack --stack-name ${STACK_NAME}; then
    echo "Package ${STACK_NAME} removed successfully"
else
    echo "Failed removing package ${STACK_NAME}"
fi