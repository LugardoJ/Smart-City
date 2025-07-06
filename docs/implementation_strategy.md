# 🚀 IMPLEMENTATION_STRATEGY.md – Smart City

This document outlines the team distribution, technical stack, quality assurance measures, and modular strategy used to build the Smart City app in a scalable, testable, and maintainable way.

---

## 🧠 Technical Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI (iOS 18 SDK), Observable macro |
| Architecture | Clean Architecture (SOLID), MVVM |
| Dependency Injection | Protocol-based, injected at ViewModel/UseCase |
| Persistence | SwiftData (`CityEntity`), in-memory caching |
| Metrics & Analytics | Custom `MetricsRecording`, Amplitude |
| API Integration | Wikipedia REST endpoint |
| Tooling | SwiftLint, SwiftFormat, GitHub Actions, Xcode 16+ |

---

## 👥 Team Roles & Flow

| Role | Responsibility |
|------|----------------|
| Developer | Implements features under `feature/*` branches, no direct push to `develop` or `main` |
| Maintainer | Reviews PRs, handles merges to `develop` and `main`, manages GitHub Secrets |
| CI Runner | Executes tests, linters, and formatters on all PRs automatically |

Developers are restricted to creating and updating features. No forks or unverified commits are permitted.

---

## 🧱 Modular Organization

The app is structured by domain module:

- `Search` – Search queries, recent terms, debounce
- `Favorites` – Favorite toggle, filtering, persistence
- `Detail` – Map, markers, detail card (`CityInfoCard`)
- `Summary` – Wikipedia fetch, card content
- `Metrics` – Load/search/visit metrics, dashboard
- `Coordinator` – Navigation stack, path, and flow controller

Each module has isolated dependencies and its own ViewModel, UseCases, and Repositories.

---

## ✅ Quality Assurance

| Tool | Purpose |
|------|---------|
| SwiftLint | Enforces code style and best practices |
| SwiftFormat | Auto-formats Swift source code |
| GitHub Actions | CI pipeline: lint, format, build, test |
| XCTest | Validates ViewModels, UseCases, Repositories |
| XCUITest | Validates UI interactions and flows |
| Amplitude | Tracks user interaction and screen metrics |

---

## 🧪 Testing Coverage

- Unit tests for ViewModels and UseCases
- UI tests for flows like Search, Detail, Metrics
- Mock repositories for protocol-level isolation
- Fixtures included in `/Fixtures/` folder

---


## 🔐 Git & Workflow Rules

The project follows a GitFlow-like branching strategy with the following main branches:

| Branch | Purpose |
|--------|---------|
| `develop` | Active development branch. All features are merged here first. |
| `staging` | Pre-production environment for QA and validation. |
| `production` | Final production environment for internal release tests. |
| `main` | Holds the last **official release** version. |

Additional branches:

- `feature/<name>` – Feature-specific branches created by developers
- `hotfix/<name>` – Urgent patches branched from `main`

### 🚫 Restrictions

- Developers **cannot push directly** to `main` or `develop`
- All changes must go through a **Pull Request**
- CI/CD must pass before any merge is accepted
- Forks are disabled to ensure internal control

### ✅ Release Management

While `main` represents the last deployed release, **tagged releases** can also be used to mark stable points in history.

> Optionally, you can use **GitHub Releases** with version tags to store release notes, binaries, or screenshots for each deployment milestone.


- Feature branches: `feature/<name>`
- No push access to `develop` or `main` by default
- PRs are mandatory with CI validation
- `main` reflects production
- `develop` reflects staging/QA

---

## ✅ Summary

The implementation strategy of Smart City ensures:

- Clean separation of concerns
- Maintainability through modular design
- Robust testability and metric observability
- Strict control over source integrity and deployments

Ready to scale across teams and future feature sets.

