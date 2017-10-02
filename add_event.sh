#!/usr/bin/env bash

SUBMISSION_BUCKET_NAME="mug-shot-submission-s3"
LAUNCH_STATE_MACHINE_FUNCTION="arn:aws:lambda:eu-central-1:667791141321:function:mugshot-lambda-LaunchSubmissionStateMachineFunctio-XXXXXXXXXXXXXXX"

# Check if the aws cli is installed
if ! command -v aws > /dev/null; then
    echo "aws cli was not found. Please install before running this script."
    exit 1
fi

if aws lambda add-permission --function-name ${LAUNCH_STATE_MACHINE_FUNCTION} --statement-id "InvokeFunction" --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn "arn:aws:s3:::${SUBMISSION_BUCKET_NAME}"; then
    echo "lambda successfully added permission the event"
else
    echo "Failed adding permission"
    exit 1
fi

if aws s3api put-bucket-notification-configuration --bucket ${SUBMISSION_BUCKET_NAME} --notification-configuration file://cloudformation/mugshot-event.json; then
    echo "s3api successfully created the event"
else
    echo "Failed creating s3api event"
    exit 1
fi
