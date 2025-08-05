#!/bin/bash

# Test runner script for Terraform Secure Landing Zone
# This script runs all Terratest tests in the correct order

set -e

echo "🧪 Running Terraform Secure Landing Zone Tests"
echo "================================================"

# Change to test directory
cd "$(dirname "$0")"

# Ensure Go modules are up to date
echo "📦 Updating Go modules..."
go mod tidy

# Run tests in parallel where possible
echo "🚀 Running all tests..."
go test -v -timeout 30m ./...

echo "✅ All tests completed!" 