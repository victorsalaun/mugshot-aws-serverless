#!/usr/bin/env bash

TEMPLATE_FILE_NAME='mugshot.cfn.yml'
PACKAGE_FILE_NAME='mugshot-xfm.cfn.yml'
STACK_NAME='MugShot'
BUCKET_NAME_TEMPLATE="mug-shot-template-s3"

# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

# Try to create CloudFormation package
if aws cloudformation package --template-file cloudformation/${TEMPLATE_FILE_NAME} --output-template-file ${PACKAGE_FILE_NAME} --s3-bucket ${BUCKET_NAME_TEMPLATE}; then
    echo "CloudFormation successfully created the package ${PACKAGE_FILE_NAME}"
else
    echo "Failed creating CloudFormation package"
    exit 1
fi

# Try to deploy the package
if aws cloudformation deploy --template-file ${PACKAGE_FILE_NAME} --stack-name ${STACK_NAME} --capabilities CAPABILITY_IAM; then
    echo "CloudFormation successfully deployed the serverless app package"
else
    echo "Failed deploying CloudFormation package"
    exit 1
fi