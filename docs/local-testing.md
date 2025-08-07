# Local Testing with Act

This document explains how to run GitHub Actions locally using [act](https://github.com/nektos/act).

## Prerequisites

1. Install `act`:
   ```bash
   # macOS
   brew install act
   
   # Linux
   curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   
   # Windows
   choco install act-cli
   ```

2. Install Docker (required by act)

## Setup

1. **Create a `.secrets` file** in the project root:
   ```bash
   # Copy the example and update with your values
   cp .secrets.example .secrets
   ```

2. **Update the `.secrets` file** with your actual AWS credentials:
   ```bash
   AWS_ACCESS_KEY_ID=your-actual-access-key
   AWS_SECRET_ACCESS_KEY=your-actual-secret-key
   AWS_ACCOUNT_ID=your-actual-account-id
   ```

## Running Tests

### Run all jobs
```bash
act --secret-file .secrets -W .github/workflows/ci.yml
```

### Run specific jobs
```bash
# Run only validation
act --secret-file .secrets -W .github/workflows/ci.yml validate

# Run only tests
act --secret-file .secrets -W .github/workflows/ci.yml test

# Run only format and lint
act --secret-file .secrets -W .github/workflows/ci.yml fmt-lint
```

### Run with specific matrix values
```bash
# Test specific example
act --secret-file .secrets -W .github/workflows/ci.yml validate -e <(echo '{"matrix":{"example":"basic"}}')

# Test specific test type
act --secret-file .secrets -W .github/workflows/ci.yml test -e <(echo '{"matrix":{"test":"basic"}}')
```

## Troubleshooting

### Common Issues

1. **Docker not running**: Make sure Docker is running on your system
2. **Permission issues**: On Linux/macOS, you might need to run with `sudo`
3. **Memory issues**: Increase Docker memory allocation if tests fail due to memory constraints

### Debug Mode

Run with verbose output to see what's happening:
```bash
act --secret-file .secrets -W .github/workflows/ci.yml --verbose
```

### Clean Up

Remove act containers and images:
```bash
docker system prune -f
```

## Environment Variables

The following environment variables are automatically set by the workflow:

- `AWS_DEFAULT_REGION=us-east-1`
- `TF_LOG=INFO`

## Secrets Required

The following secrets must be set in your `.secrets` file:

| Secret | Description | Example |
|--------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | AWS access key | `AKIA...` |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | `wJalr...` |
| `AWS_ACCOUNT_ID` | AWS account ID | `123456789012` |

## Notes

- The `.secrets` file is already in `.gitignore` to prevent accidental commits
- All examples now have sensible defaults, so no additional variables need to be set
- Tests will create actual AWS resources, so ensure you're using a test account
- Resources are automatically cleaned up by the Terratest framework
