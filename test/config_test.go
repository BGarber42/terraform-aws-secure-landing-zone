package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConfigModule(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	accountID := aws.GetAccountId(t)
	bucketName := "test-config-" + uniqueID

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/landing_zone/config",
		Vars: map[string]interface{}{
			"account_id":         accountID,
			"region":             "us-east-1",
			"config_bucket_name": bucketName,
			"config_rules": map[string]string{
				"s3-bucket-public-read-prohibited":  "S3_BUCKET_PUBLIC_READ_PROHIBITED",
				"s3-bucket-public-write-prohibited": "S3_BUCKET_PUBLIC_WRITE_PROHIBITED",
			},
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "config-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	recorderName := terraform.Output(t, terraformOptions, "recorder_name")
	ruleARNs := terraform.OutputMap(t, terraformOptions, "rule_arns")

	assert.NotEmpty(t, recorderName, "Config recorder name should not be empty")
	assert.NotEmpty(t, ruleARNs, "Config rule ARNs should not be empty")
}
