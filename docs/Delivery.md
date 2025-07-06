# 🚚 Delivery Strategy – Smart City

This document outlines the delivery plan for the Smart City iOS application, covering how the app moves from development to testing and ultimately to production, using a phased and controlled rollout strategy.

---

## 🧱 Environments Overview

| Environment | Purpose |
|-------------|---------|
| **DEV**     | Local development and feature branches |
| **STG**     | Staging builds for QA, testing, and approvals |
| **PROD**    | Production-ready builds for App Store release |

Each environment may include separate schemes, configurations (`.xcconfig`), and entitlements.

---

## 🛠 Build Channels

| Channel | Tool |
|---------|------|
| ✅ **Manual via Xcode** | For quick local debugging and validation |
| ✅ **TestFlight** | For internal and external testers |
| 🟡 **Fastlane (Proposed)** | For automated deployment (TestFlight, App Store, etc.) |
| 🟡 **Firebase App Distribution (Optional)** | Alternative for distributing pre-production builds |

---

## 🚀 Rollout Process

### 🔁 CI Integration (Pull Request → Merge)

1. ✅ All code changes go through PR validation:
   - Linting, formatting, unit/UI tests
   - GitHub Actions enforcement
2. ✅ Merges trigger builds to STG/TestFlight for internal QA
3. 🛡️ Tagging with `release/x.x.x` triggers PROD candidate preparation (manual or CI-based)

---

## 📤 Release Management

Releases follow a versioned process:

```text
release/1.0.0 → Tagged → Build archived → Delivered to TestFlight → App Store Connect
```

Each release includes:

- Release notes
- Screenshots (optional via Fastlane)
- Manual QA checklist

---

## 🧪 QA Strategy

- Builds uploaded to TestFlight (STG) undergo a manual QA pass
- Smoke test checklist:
  - Search functionality
  - Map and detail view rendering
  - Favorite toggle and persistence
  - Metrics collection
- UI snapshot comparison (when enabled)

---

## 🔐 Credentials & Security

- Provisioning profiles and certificates are managed by Xcode for now
- For Fastlane: recommend storing encrypted in GitHub Secrets or with `match`

---

## 🧠 Post-Release Observability

After deployment, metrics are monitored via:

- ✅ Amplitude dashboards (usage, city engagement, search behavior)
- ✅ Local SwiftData analytics (offline analysis, custom dashboards)

---

## 🔒 Branch Protection & Access Control

To ensure code integrity and prevent unauthorized changes, the following branch policies are enforced:

### ✅ Permissions & Roles

| Role | Permissions |
|------|-------------|
| **Developers** | Can create and work on `feature/*` branches only |
| **Maintainers** | Have write access to `develop` and manage protected branches |
| **Admins** | Full control including release approvals and CI configuration |

### 🛡️ Branch Protection Rules

- 🔒 `develop` is **write-protected**:
  - Only maintainers can merge
  - All PRs must pass CI (SwiftLint, SwiftFormat, Tests)
  - No direct pushes allowed
- 🔐 `main` is **more strictly protected**:
  - Merges allowed only via validated PRs from `develop`
  - No direct commits or emergency fixes without maintainer override
- ❌ **Forking is disabled**:
  - Ensures sensitive data and release paths remain in a controlled environment

### ✅ PR Flow

```text
feature/xyz → PR → develop
(develop protected: CI must pass)
↓
PR validated → Merge by maintainer only
↓
develop → main (via release PR/tag)
```

This setup ensures that all contributions are reviewed, tested, and traceable—maintaining a high standard of quality and security throughout the delivery lifecycle.


## ✅ Summary

The delivery process ensures a stable, testable, and incrementally shippable product, and sets the foundation for CI/CD-based automation via Fastlane in a future phase.

