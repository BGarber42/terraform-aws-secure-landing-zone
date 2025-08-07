#!/bin/bash

# Setup script for Terraform test variables
# This script helps set up the required variables for local testing

set -e

echo "🔧 Setting up Terraform test variables..."
echo "========================================"

# Get AWS account ID
echo "📋 Getting AWS account ID..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

if [ -z "$ACCOUNT_ID" ]; then
    echo "❌ Error: Could not get AWS account ID. Make sure you have AWS credentials configured."
    exit 1
fi

echo "✅ AWS Account ID: $ACCOUNT_ID"

# Generate unique bucket names
TIMESTAMP=$(date +%s)
CLOUDTRAIL_BUCKET="test-cloudtrail-logs-$TIMESTAMP"
GUARDDUTY_BUCKET="test-guardduty-findings-$TIMESTAMP"

echo "📦 Generated bucket names:"
echo "   CloudTrail: $CLOUDTRAIL_BUCKET"
echo "   GuardDuty: $GUARDDUTY_BUCKET"

# Create terraform.tfvars file
cat > terraform.tfvars << EOF
# Test variables for local development
account_id = "$ACCOUNT_ID"
cloudtrail_bucket_name = "$CLOUDTRAIL_BUCKET"
guardduty_findings_bucket_name = "$GUARDDUTY_BUCKET"
region = "us-east-1"
tags = {
  Environment = "test"
  Owner       = "local-dev"
  Project     = "secure-landing-zone"
}
EOF

echo "✅ Created terraform.tfvars file with test variables"
echo ""
echo "🚀 You can now run:"
echo "   terraform plan"
echo "   terraform apply"
echo ""
echo "⚠️  Note: These bucket names are for testing only. Use different names for production."
