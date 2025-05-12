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

# === Create S3 bucket if it does not exist ===
echo "Checking if S3 bucket '$BUCKET_NAME' exists..."

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "S3 bucket '$BUCKET_NAME' already exists. Skipping creation."
else
  echo "S3 bucket '$BUCKET_NAME' does not exist. Creating..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"

  check_success "S3 bucket creation"
fi

# === Function to create DynamoDB table if it does not exist ===
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

# Create a Jenkins server
cd ./jenkins-vault_server
terraform init
terraform fmt --recursive
terraform validate
terraform apply -auto-approve -lock=false

# Get formatted output from terraform output
ids_output=$(terraform output -json | jq -r 'to_entries[] | "  \(.key) = \"\(.value.value)\""')

# Replace the entire locals block in main.tf
awk -v data="$ids_output" '
  BEGIN { in_block=0 }
  /^locals[ \t]*{/ {
    print "locals {"
    print data
    in_block=1
    next
  }
  in_block && /^\}/ { print "}"; in_block=0; next }
  !in_block { print }
' ../main.tf > tmpfile && mv tmpfile ../main.tf


# ids_output=$(terraform output)
# printf '%s\n' "$ids_output" | awk '{print "  " $0}' | sed '3r /dev/stdin' ../main.tf > tmpfile && mv tmpfile ../main.tf