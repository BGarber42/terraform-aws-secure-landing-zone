package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {
	t.Parallel()

	// Generate a unique name for resources
	uniqueID := random.UniqueId()

	// Get AWS account ID
	accountID := aws.GetAccountId(t)

	// Configure Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/landing_zone/vpc",
		Vars: map[string]interface{}{
			"account_id": accountID,
			"region":     "us-east-1",
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "vpc-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"Error applying plan": "Temporary infrastructure issues",
		},
	})

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the infrastructure
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	publicSubnetIDs := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	privateSubnetIDs := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	internetGatewayID := terraform.Output(t, terraformOptions, "internet_gateway_id")
	natGatewayID := terraform.Output(t, terraformOptions, "nat_gateway_id")

	// Assertions
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	assert.Len(t, publicSubnetIDs, 2, "Should have 2 public subnets")
	assert.Len(t, privateSubnetIDs, 2, "Should have 2 private subnets")
	assert.NotEmpty(t, internetGatewayID, "Internet Gateway ID should not be empty")
	assert.NotEmpty(t, natGatewayID, "NAT Gateway ID should not be empty")

	t.Log("VPC module test completed successfully")
} 