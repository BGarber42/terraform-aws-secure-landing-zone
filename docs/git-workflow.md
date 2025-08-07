# Git Workflow: Linear History

This project uses a linear history workflow to maintain clean commit history and simplify release management.

## Workflow Overview

```
main:     A---B---C---D (release commits)
develop:  A---B---C---D (development commits)
feature:  A---B---E---F (feature branches)
```

## Branch Strategy

### Main Branch (`main`)
- **Purpose**: Production-ready code and releases
- **Protection**: 
  - Requires 2 approvals
  - Requires code owner review
  - Linear history enforced
  - Required signatures
  - Only merge commits allowed
- **Workflow**: Receives fast-forward merges from `develop` for releases

### Develop Branch (`develop`)
- **Purpose**: Integration branch for ongoing development
- **Protection**:
  - Requires 1 approval
  - Only rebase merges allowed
  - Status checks required
- **Workflow**: Receives rebase merges from feature branches

### Feature Branches
- **Purpose**: Individual features and fixes
- **Naming**: `feature/description` or `fix/description`
- **Workflow**: Created from `develop`, merged back via PR with rebase

## Development Process

### 1. Starting New Work
```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name
```

### 2. Making Changes
```bash
# Make your changes
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/your-feature-name
```

### 3. Creating Pull Request
- Create PR from feature branch → `develop`
- Ensure all status checks pass
- Get required approvals
- Merge with rebase (maintains linear history)

### 4. Release Process
```bash
# When ready for release
git checkout main
git merge develop --ff-only  # Fast-forward merge
git tag v1.2.3  # Tag the release
git push origin main --tags
```

### 5. Reset Develop
```bash
# After successful release
git checkout develop
git reset --hard main  # Reset develop to match main
git push origin develop --force
```

## Benefits

1. **Clean History**: Single linear commit history
2. **Easy Releases**: Simple fast-forward merges
3. **Terraform Registry**: Clean history important for module releases
4. **No Merge Clutter**: No unnecessary merge commits
5. **Clear Ownership**: Each commit has clear ownership

## Branch Protection Rules

### Develop Branch
- ✅ Require pull request reviews before merging
- ✅ Require 1 approving review
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Allow rebase merging only

### Main Branch
- ✅ Require pull request reviews before merging
- ✅ Require 2 approving reviews
- ✅ Require code owner reviews
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Require linear history
- ✅ Require signed commits
- ✅ Allow merge commits only

## Status Checks

### Develop Branch Checks
- Terraform Format and Lint
- Terraform Validate (basic/full/advanced)
- Security Scan
- Documentation Check

### Main Branch Checks
- Terraform Format and Lint
- Terraform Validate and Plan (basic/full/advanced)
- Security Scan
- Terratest (basic/security/full)
- Documentation Check

## Best Practices

1. **Commit Messages**: Use conventional commits format
   - `feat: add new feature`
   - `fix: resolve issue`
   - `docs: update documentation`
   - `refactor: improve code structure`

2. **Branch Naming**: Use descriptive names
   - `feature/add-vpc-module`
   - `fix/security-scan-issues`
   - `docs/update-readme`

3. **Small Commits**: Keep commits focused and small
4. **Regular Updates**: Keep feature branches up to date with develop
5. **Clean History**: Squash commits when appropriate during PR review

## Troubleshooting

### If develop is behind main
```bash
git checkout develop
git rebase main
git push origin develop --force
```

### If feature branch is behind develop
```bash
git checkout feature/your-branch
git rebase develop
git push origin feature/your-branch --force
```

### If merge conflicts occur
```bash
# Resolve conflicts manually
git add .
git rebase --continue
```

## Release Management

1. **Versioning**: Use semantic versioning (MAJOR.MINOR.PATCH)
2. **Changelog**: Update CHANGELOG.md with release notes
3. **Tagging**: Tag releases with version numbers
4. **Terraform Registry**: Releases are automatically published to registry

## Integration with CI/CD

- **PR Checks**: Lightweight validation for develop branch
- **Main Validation**: Comprehensive validation for main branch
- **Security Scanning**: tfsec integration for security analysis
- **Testing**: Terratest for infrastructure validation
