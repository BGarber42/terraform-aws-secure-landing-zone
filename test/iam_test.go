package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestIAMModule(t *testing.T) {
	t.Parallel()

	accountID := aws.GetAccountId(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/iam",
		Vars: map[string]interface{}{
			"account_id": accountID,
			"region":     "us-east-1",
			"iam_roles": []map[string]interface{}{
				{
					"name":        "ReadOnlyAdmin",
					"description": "Read-only administrator role",
					"policy_arn":  "arn:aws:iam::aws:policy/ReadOnlyAccess",
				},
				{
					"name":        "PowerUserRestrictedIAM",
					"description": "Power user role with restricted IAM access",
					"policy_arn":  "arn:aws:iam::aws:policy/PowerUserAccess",
				},
			},
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "iam-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	roleARNs := terraform.OutputMap(t, terraformOptions, "role_arns")
	roleNames := terraform.OutputList(t, terraformOptions, "role_names")

	assert.NotEmpty(t, roleARNs, "Role ARNs should not be empty")
	assert.Len(t, roleNames, 2, "Should have 2 IAM roles")
	assert.Contains(t, roleNames, "ReadOnlyAdmin", "Should have ReadOnlyAdmin role")
	assert.Contains(t, roleNames, "PowerUserRestrictedIAM", "Should have PowerUserRestrictedIAM role")
}
