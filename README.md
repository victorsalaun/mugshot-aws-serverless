# Mugshot AWS Serverless

Deploy a Gallery app on Amazon

##Prerequisites

* aws-cli (latest)

## Install

    install_cognito.sh
    install_dynamodb.sh
    install_s3.sh

Open mugshot-lambda.cfn.yml file and replace MugDynamoDBTable's default name
    
    install_lambda.sh

Edit add_event.sh and replace LambdaFunctionArn with LaunchSubmissionStateMachineFunction's Arn

    add_event.sh

Edit app.js file, replace IdentityPoolId with Cognito pool and TableName with MugDynamoDBTable's name

    cd static
    npm install

Open index.html file

## Clean

    uninstall_lambda.sh
    uninstall_s3.sh
    uninstall_dynamodb.sh
    uninstall_cognito.sh
