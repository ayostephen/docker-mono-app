#!/bin/bash

# Defining a local name
LOCAL_NAME="auto-discovery-mono-app"

# Defining necessary variables
BUCKET_NAME="${LOCAL_NAME}-s3"
TABLE_NAME="${LOCAL_NAME}-dynamodb"
AWS_REGION="eu-west-2"
AWS_PROFILE="mchall"


check_success() {
  if [ $1 -ne 0 ]; then
    echo "❌ $2"
    exit 1
  fi
}

# === Create S3 bucket if it does not exist ===
echo "Checking if S3 bucket '$BUCKET_NAME' exists..."

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "S3 bucket '$BUCKET_NAME' already exists. Skipping creation."
else
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"

  check_success $? "S3 bucket creation"
fi


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

# ## Create a Jenkins server
# cd ./jenkins-vault_server
# terraform init
# terraform fmt --recursive
# terraform validate
# terraform apply -auto-approve -lock=false

# # Get outputs in JSON and generate valid HCL lines
# ids_output=$(terraform output -json | jq -r 'to_entries[] | "  \(.key) = \"\(.value.value)\""')

# # Replace existing locals block in main.tf (if exists)
# awk -v data="$ids_output" '
#   BEGIN { in_block=0 }
#   /^locals[ \t]*{/ {
#     print "locals {"
#     print data
#     in_block=1
#     next
#   }
#   in_block && /^\}/ { print "}"; in_block=0; next }
#   !in_block { print }
# ' ../main.tf > tmpfile && mv tmpfile ../main.tf



ids_output=$(terraform output)
printf '%s\n' "$ids_output" | awk '{print "  " $0}' | sed '3r /dev/stdin' ../main.tf > tmpfile && mv tmpfile ../main.tf