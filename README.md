# MLOps Release Management Workflow

This repository demonstrates a complete MLOps release management system using GitHub Actions, release-please, and conventional commits.

## 🔄 Branch Strategy (GitFlow)

```
Feature Branches → Dev Branch → Release Branch → Main Branch
```

### Branch Purposes:
- **`main`**: Production-ready code, always stable
- **`dev`**: Integration branch for ongoing development
- **`release-v*`**: Release preparation and testing (e.g., `release-v2.2.0`)
- **`feature/*`**: Individual feature development

## 📋 Development Workflow

### 1. Feature Development
```bash
# Create feature branch from dev
git checkout dev
git pull origin dev
git checkout -b feature/user-authentication

# Work on feature with conventional commits
git commit -m "feat: add JWT authentication system"
git commit -m "fix: resolve token expiration issue"
git commit -m "docs: update API authentication guide"

# Create PR: feature/user-authentication → dev
# Review, approve, and merge PR
```

### 2. Release Preparation
```bash
# When ready for release, create release branch from dev
git checkout dev
git pull origin dev
git checkout -b release-v2.2.0

# Test thoroughly, fix bugs if needed
git commit -m "fix: resolve integration test failures"

# Create PR: release-v2.2.0 → main
# Review, approve, and merge PR
```

### 3. Automated Release Process
```
After merging release-v2.2.0 → main:

1. release-please detects new commits in main
2. Automatically creates Release PR: "chore(main): release 2.2.0"
3. Release PR contains:
   - Updated CHANGELOG.md
   - Updated VERSION file
   - Updated pyproject.toml version
4. Review and merge Release PR
5. GitHub Release v2.2.0 created automatically
6. Docker images and artifacts built automatically
```

## 🏷️ Conventional Commits

Use conventional commit format for automatic changelog generation:

### Commit Types:
- **`feat:`** - New features (minor version bump)
- **`fix:`** - Bug fixes (patch version bump)
- **`docs:`** - Documentation changes
- **`perf:`** - Performance improvements
- **`build:`** - Build system changes
- **`ci:`** - CI/CD changes
- **`style:`** - Code style changes
- **`refactor:`** - Code refactoring
- **`test:`** - Test additions/changes
- **`chore:`** - Maintenance tasks

### Examples:
```bash
git commit -m "feat: add ML model versioning system"
git commit -m "fix: resolve memory leak in data preprocessing"
git commit -m "docs: update Kubernetes deployment guide"
git commit -m "perf: optimize inference speed by 40%"
git commit -m "feat!: breaking change in API structure"  # Major version bump
```

## 🚀 Release Types

### Semantic Versioning (SemVer):
- **Major (X.0.0)**: Breaking changes (`feat!:`, `fix!:`, or `BREAKING CHANGE`)
- **Minor (X.Y.0)**: New features (`feat:`)
- **Patch (X.Y.Z)**: Bug fixes (`fix:`)

### Examples:
- `v1.0.0` → `v1.1.0` (new feature)
- `v1.1.0` → `v1.1.1` (bug fix)
- `v1.1.1` → `v2.0.0` (breaking change)

## 🔧 Automated Workflows

### 1. Release Please (`release-please.yml`)
- **Triggers**: Push to main branch
- **Creates**: Release PR with changelog and version updates
- **Analyzes**: Conventional commits since last release

### 2. GitHub Release (`release.yml`)
- **Triggers**: Tag creation (when Release PR is merged)
- **Creates**: GitHub Release with categorized changelog
- **Includes**: Commit hashes and author attribution

### 3. Docker Release (`docker-release.yml`)
- **Triggers**: Tag creation
- **Builds**: Multi-platform Docker images (amd64/arm64)
- **Publishes**: To GitHub Container Registry (GHCR)
- **Includes**: Security scanning and SBOM generation

## 📦 Artifacts Generated

### For each release:
- **GitHub Release**: With detailed changelog
- **Docker Images**: Multi-platform containers
- **SBOM**: Software Bill of Materials
- **Security Reports**: Vulnerability scanning results

### Docker Tags Created:
```
ghcr.io/username/repo:v2.2.0    # Exact version
ghcr.io/username/repo:2.2.0     # SemVer
ghcr.io/username/repo:2.2       # Minor version
ghcr.io/username/repo:2         # Major version
ghcr.io/username/repo:latest    # Latest release
```

## 🔒 Security Features

- **Branch verification**: Releases only from main branch
- **SemVer validation**: Strict version format enforcement
- **Vulnerability scanning**: Trivy security analysis
- **SBOM generation**: Compliance and audit support
- **Multi-platform builds**: Enhanced compatibility

## 🎯 Complete Workflow Example

```
1. Developer creates feature/ml-pipeline branch
2. Commits: "feat: add distributed training support"
3. Creates PR: feature/ml-pipeline → dev
4. Team reviews and merges PR

5. When ready for release, create release-v2.2.0 from dev
6. Test and fix any issues in release branch
7. Create PR: release-v2.2.0 → main
8. Team reviews and merges PR

9. release-please automatically creates Release PR
10. Review Release PR (contains changelog and version bump)
11. Merge Release PR

12. Automatic results:
    - GitHub Release v2.2.0 created with enhanced changelog
    - Release notes include author attribution (by @username)
    - Categorized changes with emojis (🚀 Features, 🐛 Bug Fixes, etc.)
    - Docker images built and published
    - Security scanning completed
    - Artifacts available for download
```

## 🛠️ Setup Requirements

### Repository Settings:
1. Go to Settings → Actions → General
2. Select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"

### Required Files:
- `.github/workflows/release-please.yml` - Main automation with author enhancement
- `VERSION` - Version tracking
- `pyproject.toml` - Package metadata

### Optional Files:
- `.release-please-config.json` - Custom configuration (not required, uses defaults)

## 📊 Benefits

- ✅ **Automated version management** based on conventional commits
- ✅ **Professional changelogs** with categorized changes and author attribution
- ✅ **Security scanning** and compliance reporting
- ✅ **Multi-platform Docker images** for broad compatibility
- ✅ **Review process** for all releases through PRs
- ✅ **Full traceability** from commits to releases
- ✅ **Production-ready** MLOps deployment pipeline

## 🔗 Useful Links

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [release-please Documentation](https://github.com/googleapis/release-please)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

**This workflow provides enterprise-grade release management for MLOps projects with full automation, security, and compliance features.** 🚀
