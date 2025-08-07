package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestLandingZoneBasic(t *testing.T) {
	t.Parallel()

	// Generate unique names for resources
	uniqueID := random.UniqueId()
	cloudtrailBucketName := "test-cloudtrail-" + uniqueID
	guarddutyFindingsBucketName := "test-guardduty-findings-" + uniqueID

	// Get AWS account ID
	accountID := aws.GetAccountId(t)

	// Configure Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		Vars: map[string]interface{}{
			"account_id":                     accountID,
			"region":                         "us-east-1",
			"cloudtrail_bucket_name":         cloudtrailBucketName,
			"guardduty_findings_bucket_name": guarddutyFindingsBucketName,
			"enable_guardduty":               true,
			"enable_budget_alerts":           true,
			"enable_budget_actions":          false,
			"budget_limit_usd":               100.0,
			"budget_alert_subscribers":       []string{"test@example.com"},
			"enable_security_hub":            false,
			"enable_macie":                   false,
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "landing-zone-test",
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
	cloudtrailBucketARN := terraform.Output(t, terraformOptions, "cloudtrail_bucket_arn")
	guarddutyDetectorID := terraform.Output(t, terraformOptions, "guardduty_detector_id")
	budgetID := terraform.Output(t, terraformOptions, "budget_id")

	// VPC Assertions
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	assert.Len(t, publicSubnetIDs, 2, "Should have 2 public subnets")
	assert.Len(t, privateSubnetIDs, 2, "Should have 2 private subnets")

	// CloudTrail Assertions
	assert.NotEmpty(t, cloudtrailBucketARN, "CloudTrail bucket ARN should not be empty")

	// GuardDuty Assertions
	assert.NotEmpty(t, guarddutyDetectorID, "GuardDuty detector ID should not be empty")

	// Budget Assertions
	assert.NotEmpty(t, budgetID, "Budget ID should not be empty")

	t.Log("Basic landing zone test completed successfully")
}

func TestLandingZoneFull(t *testing.T) {
	t.Parallel()

	// Generate unique names for resources
	uniqueID := random.UniqueId()
	cloudtrailBucketName := "test-cloudtrail-full-" + uniqueID
	guarddutyFindingsBucketName := "test-guardduty-findings-full-" + uniqueID

	// Get AWS account ID
	accountID := aws.GetAccountId(t)

	// Configure Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/landing_zone",
		Vars: map[string]interface{}{
			"account_id":                     accountID,
			"region":                         "us-east-1",
			"cloudtrail_bucket_name":         cloudtrailBucketName,
			"guardduty_findings_bucket_name": guarddutyFindingsBucketName,
			"enable_guardduty":               true,
			"enable_budget_alerts":           true,
			"enable_budget_actions":          false,
			"budget_limit_usd":               100.0,
			"budget_alert_subscribers":       []string{"test@example.com"},
			"enable_security_hub":            true,
			"enable_cis_standard":            true,
			"enable_pci_standard":            false,
			"enable_action_targets":          true,
			"enable_macie":                   true,
			"enable_macie_s3_classification": true,
			"macie_s3_buckets_to_scan":       []string{"test-bucket-1", "test-bucket-2"},
			"macie_excluded_file_extensions": []string{"jpg", "png", "gif"},
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "landing-zone-full-test",
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
	cloudtrailBucketARN := terraform.Output(t, terraformOptions, "cloudtrail_bucket_arn")
	guarddutyDetectorID := terraform.Output(t, terraformOptions, "guardduty_detector_id")
	budgetID := terraform.Output(t, terraformOptions, "budget_id")
	securityHubEnabled := terraform.Output(t, terraformOptions, "security_hub_enabled")
	macieEnabled := terraform.Output(t, terraformOptions, "macie_enabled")

	// VPC Assertions
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	assert.Len(t, publicSubnetIDs, 2, "Should have 2 public subnets")
	assert.Len(t, privateSubnetIDs, 2, "Should have 2 private subnets")

	// CloudTrail Assertions
	assert.NotEmpty(t, cloudtrailBucketARN, "CloudTrail bucket ARN should not be empty")

	// GuardDuty Assertions
	assert.NotEmpty(t, guarddutyDetectorID, "GuardDuty detector ID should not be empty")

	// Budget Assertions
	assert.NotEmpty(t, budgetID, "Budget ID should not be empty")

	// Security Hub Assertions
	assert.Equal(t, "true", securityHubEnabled, "Security Hub should be enabled")

	// Macie Assertions
	assert.Equal(t, "true", macieEnabled, "Macie should be enabled")

	t.Log("Full landing zone test completed successfully")
}
