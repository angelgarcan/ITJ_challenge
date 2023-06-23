#!/bin/bash

# set -x

dir="$(cd "$(dirname "$0")"; pwd)" # the directory of his script file
cwd=$(pwd) # the current working directory

cd $dir

source "$dir/settings.sh"

##################################
# FAT JAR
##################################
cd ../hash-generator
mvn clean package
cd -

##################################
# LAMBDA FUNCTION
##################################

previous=$(aws iam list-roles \
    --query "Roles[?RoleName=='$LAMBDA_ROLE_NAME'].RoleName" \
    --output text)

if [[ -n "$previous" ]]; then
    # to delete previous `LAMBDA_ROLE_NAME` role, you must detach policy first
    aws iam detach-role-policy \
        --role-name $LAMBDA_ROLE_NAME \
        --policy-arn $LAMBDA_POLICY_ARN 2>/dev/null

    # delete previous `LAMBDA_ROLE_NAME` role
    aws iam delete-role \
        --role-name $LAMBDA_ROLE_NAME
fi

# create the lambda role
echo -n '=== create-role: '
aws iam create-role \
    --role-name $LAMBDA_ROLE_NAME \
    --assume-role-policy-document file://$LAMBDA_ROLE_POLICY_FILE \
    --query 'Role.Arn' \
    --output text

# get the lambda role Arn
LAMBDA_ROLE_ARN=$(aws iam get-role \
    --role-name $LAMBDA_ROLE_NAME \
    --query 'Role.Arn' \
    --output text)
# write `LAMBDA_ROLE_ARN` into settings.sh
sed -i "s|LAMBDA_ROLE_ARN=.*$|LAMBDA_ROLE_ARN=$LAMBDA_ROLE_ARN|" "$dir/settings.sh"

# display AWSLambdaBasicExecutionRole content
echo -n '=== policy-arn: '
aws iam get-policy-version \
    --version-id v1 \
    --policy-arn $LAMBDA_POLICY_ARN

# attach the `AWSLambdaBasicExecutionRole` policy to the lambda role
aws iam attach-role-policy \
    --role-name $LAMBDA_ROLE_NAME \
    --policy-arn $LAMBDA_POLICY_ARN

# display attached policies
echo -n '=== attached-role-policies: '
aws iam list-attached-role-policies \
    --role-name $LAMBDA_ROLE_NAME \
    --query 'AttachedPolicies'

# need to wait for Arn to become available
echo 'waiting the availability of the iam role...'
sleep 5

# delete `LAMBDA_FUNCTION_NAME` function silently (if exists)
aws lambda delete-function \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME 2>/dev/null

# create the `LAMBDA_FUNCTION_NAME` function
echo -n '=== lambda-function-arn: '
aws lambda create-function \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime java8 \
    --role $LAMBDA_ROLE_ARN \
    --handler com.garcan.MainFunction::handleRequest \
    --zip-file fileb://../hash-generator/target/hash-generator-1.0.jar\
    --query 'FunctionArn' \
    --output text

# get the lambda function Arn
LAMBDA_FUNCTION_ARN=$(aws lambda get-function \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME \
    --query 'Configuration.FunctionArn' \
    --output text)
# write `LAMBDA_FUNCTION_ARN` into settings.sh
sed -i "s|LAMBDA_FUNCTION_ARN=.*$|LAMBDA_FUNCTION_ARN=$LAMBDA_FUNCTION_ARN|" "$dir/settings.sh"

#### TEST LAMBDA FUNCTION
# invoke lambda function
aws lambda invoke \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME \
    --payload '{"input":"'$LAMBDA_TEST_PASSWORD'"}' \
    --query 'hash' \
    --output text \
    $LAMBDA_RESPONSE_FILE

# calculate expected and actual hashes
expected_hash=$(echo -n "$LAMBDA_TEST_PASSWORD" | sha256sum | awk '{print $1}')
actual_hash=$(cat $LAMBDA_RESPONSE_FILE | jq -r -j '.hash')

# compare hashes
if [ "$actual_hash" != "$expected_hash" ] ; then 
    echo "ERROR: On create lambda function $LAMBDA_FUNCTION_NAME. Hash values arent equal"
    exit 2
else
    echo "INFO: Lambda function $LAMBDA_FUNCTION_NAME successfully created"
fi

##################################
# API GATEWAY
##################################

# delete previous `API_GATEWAY_NAME` API gateways
aws apigateway get-rest-apis \
    --region $AWS_REGION \
    --query "items[?name=='$API_GATEWAY_NAME'].[id]" \
    --output text | while read id; do \
        aws apigateway delete-rest-api \
            --region $AWS_REGION \
            --rest-api-id "$id";
        echo "delete api-gateway-id: $id"
        echo 'deleting an API Gateway...'
        sleep 5;
    done

# create the API Gateway
echo -n '=== api-gateway-id: '
aws apigateway create-rest-api \
    --region $AWS_REGION \
    --name $API_GATEWAY_NAME \
    --endpoint-configuration types=REGIONAL \
    --query 'id' \
    --output text

# get the API Gateway id
API_GATEWAY_ID=$(aws apigateway get-rest-apis \
    --region $AWS_REGION \
    --query "items[?name=='$API_GATEWAY_NAME'].[id]" \
    --output text)
# write `API_GATEWAY_ID` into settings.sh
sed -i "s|API_GATEWAY_ID=.*$|API_GATEWAY_ID=$API_GATEWAY_ID|" "$dir/settings.sh"

# get the AWS root account id
AWS_ID=$(aws sts get-caller-identity \
    --output text \
    --query 'Account')
# write `API_GATEWAY_ARN` into settings.sh
sed -i "s|API_GATEWAY_ARN=.*$|API_GATEWAY_ARN=$API_GATEWAY_ARN|" "$dir/settings.sh"

# get the API Gateway arn 
API_GATEWAY_ARN="arn:aws:execute-api:${AWS_REGION}:${AWS_ID}:${API_GATEWAY_ID}"

# get the root path id
API_GATEWAY_ROOT_RESOURCE_ID=$(aws apigateway get-resources \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --query "items[?path=='/'].[id]" \
    --output text)
# write `API_GATEWAY_ROOT_RESOURCE_ID` into settings.sh
sed -i "s|API_GATEWAY_ROOT_RESOURCE_ID=.*$|API_GATEWAY_ROOT_RESOURCE_ID=$API_GATEWAY_ROOT_RESOURCE_ID|" "$dir/settings.sh"

# create the `API_GATEWAY_RESOURCE_NAME` resource path
echo -n '=== api-gateway-resource-id: '
aws apigateway create-resource \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --parent-id $API_GATEWAY_ROOT_RESOURCE_ID \
    --path-part "$API_GATEWAY_RESOURCE_NAME" \
    --query 'id' \
    --output text

# get the `API_GATEWAY_RESOURCE_NAME` path id
API_GATEWAY_RESOURCE_ID=$(aws apigateway get-resources \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --query "items[?path=='/$API_GATEWAY_RESOURCE_NAME'].[id]" \
    --output text)
# write `API_GATEWAY_RESOURCE_ID` into settings.sh
sed -i "s|API_GATEWAY_RESOURCE_ID=.*$|API_GATEWAY_RESOURCE_ID=$API_GATEWAY_RESOURCE_ID|" "$dir/settings.sh"

# display the paths
echo -n '=== api-gateway-resources: '
aws apigateway get-resources \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --query 'items[].{path:path, id:id}'

# create the POST method
echo -n '=== put-method: '
aws apigateway put-method \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --resource-id $API_GATEWAY_RESOURCE_ID \
    --http-method POST \
    --authorization-type NONE

# setup the POST method integration request
echo -n '=== put-integration: '
aws apigateway put-integration \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --resource-id $API_GATEWAY_RESOURCE_ID \
    --http-method POST \
    --integration-http-method POST \
    --type AWS \
    --uri "arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/$LAMBDA_FUNCTION_ARN/invocations"

# add lambda permission silently
STATEMENT_ID=api-lambda-permission-$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
echo "lambda add-permission statement-id: $STATEMENT_ID"
aws lambda add-permission \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME \
    --source-arn "$API_GATEWAY_ARN/*/POST/$API_GATEWAY_RESOURCE_NAME" \
    --principal apigateway.amazonaws.com \
    --statement-id $STATEMENT_ID \
    --action lambda:InvokeFunction &>/dev/null

# display the lambda policy
echo -n '=== lambda get-policy: '
aws lambda get-policy \
    --region $AWS_REGION \
    --function-name $LAMBDA_FUNCTION_NAME \
    --query 'Policy' \
    --output text | jq --monochrome-output

# setup the POST method responses (method + integration response)
echo -n '=== put-method-response: '
aws apigateway put-method-response \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --resource-id $API_GATEWAY_RESOURCE_ID \
    --http-method POST \
    --status-code 200 \
    --response-models '{"application/json": "Empty"}'

echo -n '=== put-integration-response: '
aws apigateway put-integration-response \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --resource-id $API_GATEWAY_RESOURCE_ID \
    --http-method POST \
    --status-code 200 \
    --content-handling CONVERT_TO_TEXT

# publish the API, create the `API_GATEWAY_DEPLOY_STAGE` stage
echo -n '=== create-deployment: '
aws apigateway create-deployment \
    --region $AWS_REGION \
    --rest-api-id $API_GATEWAY_ID \
    --stage-name $API_GATEWAY_DEPLOY_STAGE

##################################
# TESTS
##################################
test_password (){
    local TEST_PASSWORD=$1

    # print curl statement
    echo "curl -s -X POST -H \"Content-Type: application/json\" -d '{\"input\": \"'$TEST_PASSWORD'\"}' https://$API_GATEWAY_ID.execute-api.$AWS_REGION.amazonaws.com/dev/$API_GATEWAY_RESOURCE_NAME"

    # execute curl statement. Getting the response
    response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"input": "'$TEST_PASSWORD'"}' https://$API_GATEWAY_ID.execute-api.$AWS_REGION.amazonaws.com/dev/$API_GATEWAY_RESOURCE_NAME)

    actual_hash=$(echo "$response" | jq -r -j '.hash')
    # calculate expected hash
    expected_hash=$(echo -n "$TEST_PASSWORD" | sha256sum | awk '{print $1}')
    # "OK" only if the response contains the "hash" and it is equal to the expected_hash otherwise "FAIL"
    result=$([[ "$actual_hash" == "$expected_hash" ]] && echo "OK" || echo "FAIL")

    # print results
    echo -e "$result\t$TEST_PASSWORD\t-> $response\n"
}

echo '=== tests:'

# a few test cases
test_password "$LAMBDA_TEST_PASSWORD"
test_password "abcd-1234"
test_password "a1+"
test_password "password"
test_password "1234567890"
test_password "test1234"
test_password "another_pass&"

cd $cwd

echo -e "\nALL DONE !!"