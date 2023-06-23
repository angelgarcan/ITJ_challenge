#!/bin/bash

# Set your aws-secrets. See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
# export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
# export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
# export AWS_DEFAULT_REGION=<YOUR_AWS_DEFAULT_REGION>

AWS_ID=
AWS_REGION=us-east-2 # Ohio

LAMBDA_ROLE_NAME=hash-generator-role
LAMBDA_ROLE_ARN=
LAMBDA_ROLE_POLICY_FILE=lambda-role-policy.json
LAMBDA_POLICY_ARN=arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

LAMBDA_FUNCTION_NAME=hash-generator-function
LAMBDA_FUNCTION_ARN=
LAMBDA_RESPONSE_FILE=/tmp/${LAMBDA_FUNCTION_NAME}_response.json
LAMBDA_TEST_PASSWORD=Password123#

API_GATEWAY_NAME=hash-generator-api
API_GATEWAY_ID=
API_GATEWAY_ARN=
API_GATEWAY_ROOT_RESOURCE_ID=
API_GATEWAY_RESOURCE_NAME=hash-generator
API_GATEWAY_RESOURCE_ID=
API_GATEWAY_DEPLOY_STAGE=dev