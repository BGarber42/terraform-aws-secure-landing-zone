package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestCloudTrailModule(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	accountID := aws.GetAccountId(t)
	bucketName := "test-cloudtrail-" + uniqueID

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/cloudtrail",
		Vars: map[string]interface{}{
			"account_id":             accountID,
			"region":                 "us-east-1",
			"cloudtrail_bucket_name": bucketName,
			"cloudtrail_enable_kms":  true,
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "cloudtrail-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	bucketARN := terraform.Output(t, terraformOptions, "bucket_arn")
	cloudtrailARN := terraform.Output(t, terraformOptions, "cloudtrail_arn")
	kmsKeyARN := terraform.Output(t, terraformOptions, "kms_key_arn")

	assert.NotEmpty(t, bucketARN, "Bucket ARN should not be empty")
	assert.NotEmpty(t, cloudtrailARN, "CloudTrail ARN should not be empty")
	assert.NotEmpty(t, kmsKeyARN, "KMS key ARN should not be empty")
}
