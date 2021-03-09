#!/bin/bash

Name=$1
FirstExecution=$2

echo 'Deploy S3-Code...'
aws cloudformation deploy --region 'us-east-1' --stack-name 'deploy-s3-code' --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file ../cloudformation/deploy-s3-code.yml --parameter-overrides NameApp=$Name

if [ $FirstExecution = true ]
then
    echo 'FirstExecution -- Deploy S3 Image...'
    aws cloudformation deploy --region 'us-east-1' --stack-name 'deploy-s3-image' --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file ../cloudformation/deploy-s3-image.yml --parameter-overrides NameApp=$Name
fi

echo 'Get Parameter S3BUCKET'
export S3BUCKET="$(aws ssm get-parameter --name /Lambda/${Name}/S3BucketName | jq -r '.Parameter.Value')"
envsubst '${S3BUCKET}' < ../../env_sub > ../../.env

echo 'Zip...'
zip -r minify.zip ../../minify.js ../../.env ../../node_modules/

echo 'Copy for S3'
aws s3 cp minify.zip s3://optimize-s3-code  

echo 'Deploy Lambda...'
aws cloudformation deploy --region 'us-east-1' --stack-name 'deploy-lambda' --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file ../cloudformation/deploy-lambda.yml --parameter-overrides NameApp=$Name

echo 'Get Parameter LAMBDA_NAME'
export LAMBDA_NAME="$(aws ssm get-parameter --name /Lambda/${Name}/LambdaName | jq -r '.Parameter.Value')"

echo 'Deploy S3 Image After...'
aws cloudformation deploy --region 'us-east-1' --stack-name 'deploy-s3-image' --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --template-file ../cloudformation/deploy-s3-image-after.yml --parameter-overrides NameApp=$Name

echo 'Lambda Update...'
aws lambda update-function-code --function-name ${LAMBDA_NAME} --s3-bucket ${Name}-s3-code --s3-key 'minify.zip'

echo 'Clean!'
rm minify.zip
rm ../../.env