# Git Workflow: Main + Feature Branches

This project uses a simplified workflow optimized for solo development with external contributions. Small changes go directly to main, while larger features use feature branches.

## Quick Reference

### 1. Small Changes (Direct to Main)
```bash
# Quick fixes, documentation updates, small tweaks
git commit -m "docs: fix typo in README"
git push origin main
```

### 2. Larger Features (Feature Branches)
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: add new feature"
git push origin feature/your-feature-name

# Create PR: feature → main
gh pr create --title "feat: add new feature" --base main
```

### 3. External Contributions
```bash
# Contributors fork and create feature branches
git checkout -b feature/external-contribution
# ... work ...
git push origin feature/external-contribution
# Create PR: feature/external-contribution → main
```

### 4. Creating a Versioned Release
```bash
# Update CHANGELOG.md with release notes
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG for v1.2.3"
git push origin main

# Create tag and release
git tag v1.2.3
git push origin v1.2.3
gh release create v1.2.3 --title "Release v1.2.3" --notes-file CHANGELOG.md
```

## Workflow Overview

```
main:     A---B---C---D (stable releases)
feature:  A---B---E---F (feature branches)
```

## Branch Strategy

### Main Branch (`main`)
- **Purpose**: Production-ready code and releases
- **Protection**: 
  - Linear history enforced
  - Essential status checks required
  - Admin can bypass restrictions for releases
- **Workflow**: Receives direct commits for small changes, PRs for features

### Feature Branches
- **Purpose**: Individual features and fixes
- **Naming**: `feature/description` or `fix/description`
- **Workflow**: Created from `main`, merged back via PR

## Development Process

### 1. Small Changes (Direct to Main)
```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Make small changes
git add .
git commit -m "docs: fix typo"
git push origin main
```

### 2. Larger Features (Feature Branches)
```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name

# Make your changes
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/your-feature-name

# Create PR for review
gh pr create --title "feat: add new feature" --base main
```

### 3. External Contributions
- Contributors fork the repository
- Create feature branches from main
- Submit PRs for review
- Maintainer reviews and merges

### 4. Release Process
```bash
# When ready for release
# 1. Update CHANGELOG.md with release notes
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG for v1.2.3"
git push origin main

# 2. Create tag and release
git tag v1.2.3
git push origin v1.2.3

# 3. Create GitHub release
gh release create v1.2.3 --title "Release v1.2.3" --notes-file CHANGELOG.md
```

## Benefits

1. **Fast Iteration**: Small changes go directly to main
2. **Simple Workflow**: No develop branch overhead
3. **Secure External PRs**: Protected main branch
4. **Clean History**: Linear history maintained
5. **Flexible**: Feature branches when needed

## Branch Protection Rules

### Main Branch Protection
- ✅ **Linear history enforced** (maintains clean commit history)
- ✅ **Essential status checks required**:
  - Terraform Format and Lint
  - Terraform Validate and Plan (basic)
  - Security Scan
- ✅ **Admin bypass allowed** (for release management)

### Feature Branches
- ✅ **No specific protection rules** (flexible development)
- ✅ **Standard GitHub PR workflow** (optional reviews)
- ✅ **Flexible merge options** (rebase, merge, or squash)

## Status Checks

### Main Branch Checks (Required)
- ✅ **Terraform Format and Lint** (code quality)
- ✅ **Terraform Validate and Plan (basic)** (syntax validation)
- ✅ **Security Scan** (security analysis)

### PR Checks (Required for External Contributions)
- ✅ **Terraform Format and Lint** (code quality)
- ✅ **Terraform Validate** (syntax validation)
- ✅ **Security Scan** (security analysis)
- ✅ **Documentation Check** (structure validation)

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
4. **Regular Updates**: Keep feature branches up to date with main
5. **Clean History**: Squash commits when appropriate during PR review

## Troubleshooting

### If feature branch is behind main
```bash
git checkout feature/your-branch
git rebase main
git push origin feature/your-branch --force
```

### If merge conflicts occur
```bash
# Resolve conflicts manually
git add .
git rebase --continue
```

### For external contributors
- Fork the repository
- Create feature branch from main
- Submit PR for review
- Maintainer reviews and merges

## Notes

### Commits Between Tags
**Note:** Commits between tags may be in various states of development. For production use, always reference a specific tagged release.

### External Contributions
- All external contributions require review before merging to main
- Feature branches provide isolation for external work
- PR process ensures quality and security


