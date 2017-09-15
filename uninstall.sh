#!/usr/bin/env bash

TEMPLATE_FILE_NAME='mugshot.cfn.yml'
PACKAGE_FILE_NAME='mugshot-xfm.cfn.yml'
STACK_NAME='MugShot'
BUCKET_NAME_TEMPLATE="mug-shot-template-s3"
BUCKET_NAME_SUBMISSION="mug-shot-submission-s3"
BUCKET_NAME_VALID="mug-shot-submission-s3"

# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

ACCOUNT_ID=`aws iam get-user | grep 'arn:aws:iam' | tr -dc '0-9'`
REGION=`aws configure get region`

# try to empty the bucket BUCKET_NAME_SUBMISSION
if aws s3 rb s3://${BUCKET_NAME_SUBMISSION} --force; then
    echo "Bucket s3://${BUCKET_NAME_SUBMISSION} emptied successfully"
else
    echo "Failed emptying bucket s3://${BUCKET_NAME_SUBMISSION}"
fi

# try to empty the bucket BUCKET_NAME_VALID
if aws s3 rb s3://${BUCKET_NAME_VALID} --force; then
    echo "Bucket s3://${BUCKET_NAME_VALID} emptied successfully"
else
    echo "Failed emptying bucket s3://${BUCKET_NAME_VALID}"
fi

# Try to remove the package
if aws cloudformation delete-stack --stack-name ${STACK_NAME}; then
    echo "Package ${STACK_NAME} removed successfully"
else
    echo "Failed removing package ${STACK_NAME}"
fi

# try to empty the bucket BUCKET_NAME_TEMPLATE
if aws s3 rb s3://${BUCKET_NAME_TEMPLATE} --force; then
    echo "Bucket s3://${BUCKET_NAME_TEMPLATE} emptied successfully"
else
    echo "Failed emptying bucket s3://${BUCKET_NAME_TEMPLATE}"
fi

# Try to remove the bucket BUCKET_NAME_TEMPLATE
if aws s3 rb s3://${BUCKET_NAME_TEMPLATE}; then
    echo "Bucket s3://${BUCKET_NAME_TEMPLATE} removed successfully"
else
    echo "Failed removing bucket s3://${BUCKET_NAME_TEMPLATE}"
fi