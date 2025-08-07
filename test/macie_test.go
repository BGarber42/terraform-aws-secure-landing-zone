package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMacieModule(t *testing.T) {
	t.Parallel()

	accountID := aws.GetAccountId(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/macie",
		Vars: map[string]interface{}{
			"account_id":                   accountID,
			"region":                       "us-east-1",
			"enable_macie":                 true,
			"finding_publishing_frequency": "FIFTEEN_MINUTES",
			"enable_s3_classification":     true,
			"s3_buckets_to_scan":           []string{"test-bucket-1", "test-bucket-2"},
			"excluded_file_extensions":     []string{"jpg", "png", "gif"},
			"custom_data_identifiers":      map[string]interface{}{},
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "macie-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	macieEnabled := terraform.Output(t, terraformOptions, "macie_enabled")
	classificationJobEnabled := terraform.Output(t, terraformOptions, "classification_job_enabled")
	bucketsToScanCount := terraform.Output(t, terraformOptions, "buckets_to_scan_count")

	assert.Equal(t, "true", macieEnabled, "Macie should be enabled")
	assert.Equal(t, "true", classificationJobEnabled, "Classification job should be enabled")
	assert.Equal(t, "2", bucketsToScanCount, "Should have 2 buckets to scan")
}
