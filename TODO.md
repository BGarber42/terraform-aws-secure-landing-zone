# TODO: Planned Features and Improvements

## Planned Features (from CHANGELOG)

### Security and Compliance
- [ ] Expand security controls and compliance features (IAM customization, Config managed/custom rules, Security Hub actions, GuardDuty options)

### Monitoring and Alerting
- [ ] Enhance observability and notifications (CloudWatch dashboards/metrics, SNS configs, Slack/Teams integrations, custom alert policies)

### Multi-Region Support
- [ ] Strengthen multi-region operations (replication, global service config, region-specific settings, monitoring, compliance reporting)

### Networking
- [ ] Improve advanced networking (route tables, VPC peering, Transit Gateway, security groups, NACLs)

## Configuration Recorder Customization

### Recording Controls
- [ ] Support inclusive/exclusive recording by resource type (all with exclusions, or only specified types; limit to Config-supported types)
- [ ] Control global resource recording (enable/disable; guidance for non-home Regions)

### Implementation
- [ ] Provide variables, sane defaults, and validation for recording options (all/exclusions/includes/global/only-supported)

### Example Usage
```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # AWS Config customization - Record everything except noisy types
  config_all_supported = true
  config_exclusion_by_resource_types = [
    "AWS::CloudFormation::Stack",
    "AWS::CloudFormation::StackSet",
    "AWS::CloudWatch::Alarm"
  ]
  
  # Disable global resource recording in non-home regions
  config_record_global_resource_types = false
}
```

```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # AWS Config customization - Record only specific types
  config_all_supported = false
  config_resource_types = [
    "AWS::EC2::Instance",
    "AWS::EC2::SecurityGroup",
    "AWS::S3::Bucket",
    "AWS::IAM::Role"
  ]
}
```

### Notes on AWS Config Limitations
- No tag- or name-based filtering
- No region or account exclusion via recorder (scope by where it’s enabled)

## Technical Improvements

### Module Enhancements
- [ ] Add extensible security and cost features (CloudTrail selectors, GuardDuty filters, Macie jobs, Security Hub insights, budget actions)

### Documentation
- [ ] Expand docs (variables, troubleshooting, migrations, performance, security best practices)

### Testing
- [ ] Strengthen automated testing (integration, performance, security scanning, compliance, disaster recovery)

## Success Criteria

### Configuration Recorder Customization
- [ ] Users can include/exclude resource types and control global recording
- [ ] Options are documented with examples, validated, and work with Terraform/OpenTofu
- [ ] Limitations are clearly explained

### General Improvements
- [ ] Planned features implemented and tested
- [ ] Documentation comprehensive and current; examples cover major use cases
- [ ] Performance optimized; security and compliance validated via automation