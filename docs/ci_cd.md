# 🧹 CI/CD Pipeline – Smart City

This document describes the Continuous Integration and Delivery pipeline for the Smart City iOS app. The goal is to enforce quality, consistency, and automation across every pull request and deployment.

---

## ⚙️ Workflow Overview

Every pull request to `develop` or `main` triggers a GitHub Actions pipeline that performs:

1. ✅ **Linting** using SwiftLint
2. ✅ **Formatting validation** using SwiftFormat (`--dryrun`)
3. ✅ **Unit Testing** with coverage
4. ✅ **UI Testing** on simulator
5. ✅ **Log artifact generation** (`.xcresult`, Lint logs)
6. ✅ **Pre-merge validation**

The workflow file is located at:

```plaintext
.github/workflows/CI.yml
```

---

## 📦 SwiftLint Integration

- Runs via `run-swiftlint.sh` as a custom build phase
- Outputs logs to:
  - `Logs/Main/`
  - `Logs/Warnings/`
  - `Logs/Errors/`
  - `summary-latest.json` for parsing
- Enforces rules from `.swiftlint.yml`, including:
  - `analyzer_rules`
  - `opt_in_rules`

Run manually:

```bash
bash run-swiftlint.sh
```

---

## 🧹 SwiftFormat Integration

- Uses `.swiftformat` at project root
- Validates via GitHub Actions in `--dryrun` mode
- Formats locally with:

```bash
swiftformat .
```

- Git `pre-commit` hook available:

```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

## 🧪 Unit & UI Testing

- XCTest used for:
  - `Smart_CityTests` (unit tests)
  - `Smart_CityUITests` (UI tests)

CI runs:

```bash
xcodebuild test -scheme "Smart City" -destination 'platform=iOS Simulator,name=iPhone 16'
```

All `.xcresult` outputs are uploaded as CI artifacts for inspection.

---

## 📤 Deployment Strategy (Next Phase Proposal)

While deployment is currently manual or limited to TestFlight, this architecture is designed to adopt **Fastlane** as a key part of the next stage of the CI/CD pipeline.

#### ✅ Why Fastlane (Recommended for Phase 2)

Fastlane would enable:

- 🔄 **Automated build generation** (Debug, Release, Beta) with no manual steps
- 🚀 **Automated deployment** to:
  - TestFlight
  - App Store
  - Firebase App Distribution
- 🔐 **Certificate and provisioning profile management**:
  - Can be stored securely in GitHub Secrets or encrypted in the repo
- 📲 **Simplified release management**:
  - Uploads builds, screenshots, release notes, changelogs
- 🎯 **Quality consistency**:
  - Runs SwiftLint, SwiftFormat, and custom validation tasks
- 📈 **CI/CD workflow integration**:
  - Supports environment-based pipelines (e.g., STG vs. PROD)
  - Provides detailed logs for debugging failed steps
- 🤝 **Collaboration tooling**:
  - Slack, Email, Discord, and Jira integration for deployment notifications
- 🛡️ **Safe and controlled environments**:
  - Prevents misdeployments between environments (e.g., accidental STG → PROD releases)

> 🔧 Integrating Fastlane is the recommended next step to elevate the delivery process and ensure automation, safety, and team-wide visibility.
## ✅ Summary

The CI pipeline ensures:

- Stable code at every PR
- Clean, formatted, and test-verified codebase
- Artifacts and logs for every build
