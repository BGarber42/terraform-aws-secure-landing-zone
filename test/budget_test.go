package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBudgetModule(t *testing.T) {
	t.Parallel()

	accountID := aws.GetAccountId(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/budget",
		Vars: map[string]interface{}{
			"account_id":               accountID,
			"region":                   "us-east-1",
			"enable_budget_alerts":     true,
			"enable_budget_actions":    false,
			"budget_limit_usd":         100.0,
			"budget_alert_subscribers": []string{"test@example.com"},
			"tags": map[string]string{
				"Environment": "test",
				"Owner":       "terratest",
				"Project":     "budget-test",
			},
		},
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Assertions
	budgetID := terraform.Output(t, terraformOptions, "budget_id")
	budgetARN := terraform.Output(t, terraformOptions, "budget_arn")
	snsTopicARN := terraform.Output(t, terraformOptions, "sns_topic_arn")

	assert.NotEmpty(t, budgetID, "Budget ID should not be empty")
	assert.NotEmpty(t, budgetARN, "Budget ARN should not be empty")
	assert.NotEmpty(t, snsTopicARN, "SNS topic ARN should not be empty")
}
