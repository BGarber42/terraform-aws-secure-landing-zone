#!/bin/bash

# Test runner script for Terraform Secure Landing Zone
# This script sets up the test environment and runs all Terratest tests

set -e

echo "🧪 Terraform Secure Landing Zone Test Suite"
echo "============================================"

# Change to test directory
cd "$(dirname "$0")"

# Setup phase
echo "🔧 Setting up test environment..."
echo "📦 Updating Go modules..."
go mod tidy

echo "✅ Verifying dependencies..."
go mod verify

echo "🎯 Running tests..."
echo ""

# Show test count
echo "📊 Found $(go test -list . | grep -c '^Test') tests to run"
echo ""

# Run tests in parallel where possible
go test -v -timeout 30m ./...

echo ""
echo "✅ All tests completed!"
echo ""
echo "💡 Tips:"
echo "  - Run specific tests: go test -v -run TestName"
echo "  - Run with coverage: go test -v -cover ./..."
echo "  - Run in verbose mode: go test -v -timeout 30m ./..." 