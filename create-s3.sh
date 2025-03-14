#!/bin/bash

# Defining a local name
LOCAL_NAME="auto-discovery-mono-app"

# Defining necessary variables
BUCKET_NAME="${LOCAL_NAME}-s3"
TABLE_NAME="${LOCAL_NAME}-dynamodb"
AWS_REGION="eu-west-2"
AWS_PROFILE="petproject"

# Function to check command success
# check_success() {
#     if [ $? -eq 0 ]; then
#         echo "$1 succeeded."
#     else
#         echo "$1 failed." >&2
#         exit 1
#     fi
# }

check_bucket_exists() {
    BUCKET_NAME=$1
    
    if aws s3 ls "s3://$BUCKET_NAME" 2>/dev/null; then
        echo "Bucket '$BUCKET_NAME' already exists. Skipping creation."
    else
        echo "Bucket '$BUCKET_NAME' does not exist. Proceeding with creation..."
        aws s3 mb "s3://$BUCKET_NAME"
        echo "Bucket '$BUCKET_NAME' created successfully."
    fi
}

# Function to check if a DynamoDB table exists
check_dynamodb_table() {
    TABLE_NAME=$1
    AWS_REGION=$2
    AWS_PROFILE=$3

    echo "Checking if DynamoDB table '$TABLE_NAME' exists..."

    if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" &>/dev/null; then
        echo "DynamoDB table '$TABLE_NAME' already exists. Skipping creation."
    else
        echo "DynamoDB table '$TABLE_NAME' does not exist. Creating..."

        aws dynamodb create-table \
            --table-name "$TABLE_NAME" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
            --region "$AWS_REGION" --profile "$AWS_PROFILE"

        check_success "DynamoDB table creation"
    fi
}


# Call function
check_dynamodb_table "$TABLE_NAME" "$AWS_REGION" "$AWS_PROFILE"


# # Create S3 bucket
# echo "Creating S3 bucket: $S3_BUCKET_NAME ..."
# aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" --create-bucket-configuration LocationConstraint="$AWS_REGION" 
# check_success "S3 bucket creation"
# # Enable versioning on the bucket
# echo "Enabling versioning on S3 bucket: $S3_BUCKET_NAME ..."
# aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled
# check_success "S3 versioning enabled"


# # Create DynamoDB table
# echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME ..."
# aws dynamodb create-table \
#     --table-name "$DYNAMODB_TABLE_NAME" \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
#     --region "$AWS_REGION" --profile "$AWS_PROFILE"
# check_success "DynamoDB table creation"

## Create a Jenkins server
cd ./jenkins-vault_server
terraform init
terraform fmt --recursive
terraform validate
terraform apply -auto-approve