#!/bin/bash
# set -x
# Variables
BUCKET_NAME="auto-discovery-bucket"
DYNAMODB_TABLE_NAME="AutoDiscoveryTable"
REGION="eu-west-2"
PROFILE="petproject" 

# Create S3 bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --profile $PROFILE --create-bucket-configuration LocationConstraint=$REGION


# Create DynamoDB table
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=10 \
    --region $REGION \
    --profile $PROFILE

# # # Create a Jenkins server
cd ./jenkins-vault_server
terraform init
terraform fmt --recursive
terraform validate
terraform apply -auto-approve