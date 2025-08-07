package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecurityHubModule(t *testing.T) {
	t.Parallel()

	accountID := aws.GetAccountId(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/landing_zone/security_hub",
		Vars: map[string]interface{}{
			"account_id":            accountID,
			"region":                "us-east-1",
			"enable_security_hub":   true,
			"enable_cis_standard":   true,
			"enable_pci_standard":   false,
			"enable_action_targets": true,
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "security-hub-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	securityHubEnabled := terraform.Output(t, terraformOptions, "security_hub_enabled")
	cisStandardEnabled := terraform.Output(t, terraformOptions, "cis_standard_enabled")
	actionTargetsEnabled := terraform.Output(t, terraformOptions, "action_targets_enabled")

	assert.Equal(t, "true", securityHubEnabled, "Security Hub should be enabled")
	assert.Equal(t, "true", cisStandardEnabled, "CIS standard should be enabled")
	assert.Equal(t, "true", actionTargetsEnabled, "Action targets should be enabled")
}
