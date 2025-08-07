package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestGuardDutyModule(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	accountID := aws.GetAccountId(t)
	findingsBucketName := "test-guardduty-findings-" + uniqueID

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/landing_zone/guardduty",
		Vars: map[string]interface{}{
			"account_id":                     accountID,
			"region":                         "us-east-1",
			"enable_guardduty":               true,
			"guardduty_findings_bucket_name": findingsBucketName,
			"guardduty_kms_key_arn":          "",
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "guardduty-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	detectorID := terraform.Output(t, terraformOptions, "detector_id")
	detectorARN := terraform.Output(t, terraformOptions, "detector_arn")
	findingsBucketARN := terraform.Output(t, terraformOptions, "findings_bucket_arn")

	assert.NotEmpty(t, detectorID, "GuardDuty detector ID should not be empty")
	assert.NotEmpty(t, detectorARN, "GuardDuty detector ARN should not be empty")
	assert.NotEmpty(t, findingsBucketARN, "Findings bucket ARN should not be empty")
}
