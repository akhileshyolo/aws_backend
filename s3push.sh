#!/bin/bash
mkdir packages
bestzip packages/createTodo.zip create-todo/*
bestzip packages/readTodo.zip read-todo/*
aws s3 cp packages s3://bucket1j5/functions/ --recursive

aws cloudformation validate-template --template-body file://template.yaml
aws cloudformation validate-template --template-body file://api.yaml

api_region='us-east-1'

is_stack_exist () {
    if ! aws cloudformation describe-stacks --region $api_region --stack-name $1 ; then
        return 1
    else
        return 0
    fi
}


Run Cloudformation Template
if ! is_stack_exist "lambda-stack" ; then
    echo "doesnt exist lambda-stack"
    aws cloudformation create-stack --stack-name lambda-stack --template-body file://template.yaml --parameters ParameterKey=QSS3BucketName,ParameterValue=bucket1j5 ParameterKey=QSS3KeyPrefix,ParameterValue=demo --capabilities CAPABILITY_NAMED_IAM
    aws cloudformation wait stack-create-complete --stack-name lambda-stack
else
    aws cloudformation update-stack --stack-name lambda-stack --template-body file://template.yaml --parameters ParameterKey=QSS3BucketName,ParameterValue=bucket1j5 ParameterKey=QSS3KeyPrefix,ParameterValue=demo --capabilities CAPABILITY_NAMED_IAM
    aws cloudformation wait stack-update-complete --stack-name lambda-stack
fi



# Run APIGateway Cloudformation Template
if ! is_stack_exist "apiDemo" ; then
    echo "doesnt API"
    aws cloudformation create-stack --stack-name apiDemo --template-body file://api.yaml
    aws cloudformation wait stack-create-complete --stack-name apiDemo
else
    aws cloudformation update-stack --stack-name apiDemo --template-body file://api.yaml
    aws cloudformation wait stack-update-complete --stack-name apiDemo
fi


ApiGatewayEndpoint=$(aws cloudformation describe-stacks --stack-name apiDemo --query Stacks[0].Outputs[0].OutputValue | tr -d '"')
echo $ApiGatewayEndpoint
curl -vvv -X POST -d '{"title": "AWS backend", "task": "Complete AWS cloud assignment"}' -H "Content-Type: application/json" $ApiGatewayEndpoint/task
curl -vvv -X GET $ApiGatewayEndpoint/task/1