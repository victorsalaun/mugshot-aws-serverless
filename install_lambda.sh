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

# aws s3 create-bucket --bucket ${BUCKET_CODE}

# zip
#zip ./lambda/src/deleteSubmittedFile/deleteSubmittedFile.zip ./lambda/src/deleteSubmittedFile/deleteSubmittedFile.py
#zip ./lambda/src/extractAndValidateSubmittedFile/extractAndValidateSubmittedFile.zip ./lambda/src/extractAndValidateSubmittedFile/extractAndValidateSubmittedFile.py
aws s3 cp ./lambda/src/copySubmittedFile/copySubmittedFile.zip  s3://${BUCKET_CODE}/copySubmittedFile.zip
aws s3 cp ./lambda/src/deleteSubmittedFile/deleteSubmittedFile.zip  s3://${BUCKET_CODE}/deleteSubmittedFile.zip
aws s3 cp ./lambda/src/extractAndValidateSubmittedFile/extractAndValidateSubmittedFile.zip  s3://${BUCKET_CODE}/extractAndValidateSubmittedFile.zip
aws s3 cp ./lambda/src/launchSubmissionStateMachine/launchSubmissionStateMachine.zip  s3://${BUCKET_CODE}/launchSubmissionStateMachine.zip
aws s3 cp ./lambda/src/saveInTableSubmittedFileInfo/saveInTableSubmittedFileInfo.zip  s3://${BUCKET_CODE}/saveInTableSubmittedFileInfo.zip

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