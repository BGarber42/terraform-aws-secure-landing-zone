# TODO: Planned Features and Improvements

## Planned Features (from CHANGELOG)

### Additional Security Features and Compliance Controls
- [ ] Enhanced IAM role customization options
- [ ] Additional AWS Config managed rules
- [ ] Custom compliance rule creation
- [ ] Security Hub custom action targets
- [ ] Advanced GuardDuty configuration options

### Enhanced Monitoring and Alerting Capabilities
- [ ] CloudWatch dashboard integration
- [ ] Custom metric collection
- [ ] Advanced SNS notification configurations
- [ ] Slack/Teams integration for alerts
- [ ] Custom alert thresholds and conditions

### Multi-Region Deployment Support
- [ ] Cross-region resource replication
- [ ] Global service configuration (IAM, CloudTrail)
- [ ] Region-specific customization options
- [ ] Multi-region monitoring and alerting
- [ ] Cross-region compliance reporting

### Advanced Networking Configurations
- [ ] Custom route table configurations
- [ ] VPC peering support
- [ ] Transit Gateway integration
- [ ] Custom security group rules
- [ ] Network ACL customization

## Configuration Recorder Customization

### AWS Config Resource Ignore Patterns
- [ ] Add support for ignoring specific resource types
- [ ] Add support for ignoring resources by tags
- [ ] Add support for ignoring resources by name patterns
- [ ] Add support for ignoring resources by ARN patterns
- [ ] Add support for ignoring resources by region

### Implementation Details
- [ ] Add `config_ignore_resource_types` variable (list of resource types to ignore)
- [ ] Add `config_ignore_resource_tags` variable (map of tag key-value pairs to ignore)
- [ ] Add `config_ignore_resource_names` variable (list of resource name patterns to ignore)
- [ ] Add `config_ignore_resource_arns` variable (list of ARN patterns to ignore)
- [ ] Add `config_ignore_regions` variable (list of regions to exclude from recording)

### Example Usage
```hcl
module "landing_zone" {
  source = "github.com/BGarber42/terraform-aws-secure-landing-zone"

  account_id = "123456789012"
  region     = "us-east-1"
  
  # AWS Config customization
  config_ignore_resource_types = [
    "AWS::CloudFormation::Stack",
    "AWS::CloudFormation::StackSet"
  ]
  
  config_ignore_resource_tags = {
    "Environment" = "test"
    "Owner"       = "temporary"
  }
  
  config_ignore_resource_names = [
    "temp-*",
    "test-*",
    "*backup*"
  ]
  
  config_ignore_regions = [
    "us-west-1",
    "eu-west-1"
  ]
}
```

## Technical Improvements

### Module Enhancements
- [ ] Add support for custom CloudTrail event selectors
- [ ] Add support for custom GuardDuty finding filters
- [ ] Add support for custom Macie classification jobs
- [ ] Add support for custom Security Hub insights
- [ ] Add support for custom budget actions

### Documentation Improvements
- [ ] Add comprehensive variable documentation
- [ ] Add troubleshooting guide
- [ ] Add migration guides for major version changes
- [ ] Add performance optimization guide
- [ ] Add security best practices guide

### Testing Improvements
- [ ] Add integration tests for all advanced features
- [ ] Add performance benchmarks
- [ ] Add security scanning tests
- [ ] Add compliance validation tests
- [ ] Add disaster recovery tests

## Success Criteria

### Configuration Recorder Customization
- [ ] Users can exclude specific resource types from AWS Config recording
- [ ] Users can exclude resources based on tags
- [ ] Users can exclude resources based on name patterns
- [ ] Users can exclude resources based on ARN patterns
- [ ] Users can exclude specific regions from recording
- [ ] All exclusions are properly documented with examples
- [ ] Exclusions are validated to prevent conflicts
- [ ] Exclusions work with both Terraform and OpenTofu

### General Improvements
- [ ] All planned features are implemented and tested
- [ ] Documentation is comprehensive and up-to-date
- [ ] Examples cover all major use cases
- [ ] Performance is optimized for large deployments
- [ ] Security is validated through automated scanning
- [ ] Compliance is verified through automated testing 