#!/bin/bash

# Defining a local name
LOCAL_NAME="auto-discovery-mono-app"

# Defining necessary variables
BUCKET_NAME="${LOCAL_NAME}-s3"
TABLE_NAME="${LOCAL_NAME}-dynamodb"
AWS_REGION="eu-west-2"
AWS_PROFILE="mchall"

# === Export AWS environment variables once ===
export AWS_REGION
export AWS_PROFILE

# === Define check_success function ===
check_success() {
  if [ $? -eq 0 ]; then
    echo "$1 succeeded."
  else
    echo "$1 failed. Exiting."
    exit 1
  fi
}

# === Create S3 bucket ===
echo "Creating S3 bucket: $BUCKET_NAME ..."
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

check_success "S3 bucket creation"

# === Function to create DynamoDB table if not exists ===
check_dynamodb_table() {
  echo "Checking if DynamoDB table '$TABLE_NAME' exists..."

  if aws dynamodb describe-table --table-name "$TABLE_NAME" &>/dev/null; then
    echo "DynamoDB table '$TABLE_NAME' already exists. Skipping creation."
  else
    echo "DynamoDB table '$TABLE_NAME' does not exist. Creating..."
    
    aws dynamodb create-table \
      --table-name "$TABLE_NAME" \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

    check_success "DynamoDB table creation"
  fi
}

# Call function
check_dynamodb_table

## Create a Jenkins server
# cd ./jenkins-vault_server
# terraform init
# terraform fmt --recursive
# terraform validate
# terraform apply -auto-approve -lock=false

# ids_output=$(terraform output)
# printf '%s\n' "$ids_output" | awk '{print "  " $0}' | sed '3r /dev/stdin' ../main.tf > tmpfile && mv tmpfile ../main.tf