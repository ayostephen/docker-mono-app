#!/bin/bash

# Defining a local name
LOCAL_NAME="auto-discovery-mono-app"

# Defining necessary variables
S3_BUCKET_NAME="${LOCAL_NAME}-s3"
DYNAMODB_TABLE_NAME="${LOCAL_NAME}-dynamodb"
AWS_REGION="eu-west-2"
AWS_PROFILE="petproject"

# Function to check command success
check_success() {
    if [ $? -eq 0 ]; then
        echo "$1 succeeded."
    else
        echo "$1 failed." >&2
        exit 1
    fi
}

# Create S3 bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME ..."
aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" --create-bucket-configuration LocationConstraint="$AWS_REGION" 
check_success "S3 bucket creation"
# # Enable versioning on the bucket
# echo "Enabling versioning on S3 bucket: $S3_BUCKET_NAME ..."
# aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled
# check_success "S3 versioning enabled"


# Create DynamoDB table
echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME ..."
aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region "$AWS_REGION" --profile "$AWS_PROFILE"
check_success "DynamoDB table creation"
