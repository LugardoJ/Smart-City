
# 📦 `Delivery.md` – Deployment & Quality Pipeline

This document outlines the code quality and deployment strategy of the **Smart City** project.  
The project integrates automated linting, formatting, and a continuous verification workflow.

---

## ✅ Code Quality Guardrails

### 🧪 SwiftLint (Linter)

To ensure code consistency and best practices, **SwiftLint** is integrated as the primary static analysis tool.

#### 🔧 Configuration

- Config file: `.swiftlint.yml`
- Executable: `run-swiftlint.sh`
- Integration: Build Phase in Xcode
- Logs:
  - 🟢 `Logs/Main/`: all results
  - 🔴 `Logs/Errors/`: only errors
  - 🟡 `Logs/Warnings/`: only warnings
  - 📊 `Logs/summary-latest.json`: automatic summary

#### 📂 Folders Included

```yaml
included:
  - "Smart City"
  - "Smart CityTests"
  - "Smart CityUITests"
```

#### 📏 Enabled Rules

- Default rules
- Extra:
  `explicit_init`, `unused_import`, `closure_spacing`, `joined_default_parameter`, `force_unwrapping`, `sorted_imports`

#### ⚠️ Complexity Limits

```yaml
function_body_length:
  warning: 40
  error: 80

cyclomatic_complexity:
  warning: 10
  error: 15
```

#### ▶️ Manual Execution

```bash
bash run-swiftlint.sh
```

---

### 🧹 SwiftFormat (Code Formatter)

To automate code formatting and enforce a consistent style, **SwiftFormat** has been added.

#### 🔧 Configuration

- Config file: `.swiftformat`
- Style: K&R, 4-space indentation, sorted imports, consistent spacing
- Swift version: 6.0

#### 🧪 Manual Execution

```bash
swiftformat .
```

#### ✅ Pre-commit Hook

A Git `pre-commit` hook automatically formats staged files before every commit.

To enable it manually:

```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

## ⚙️ Continuous Verification (CI)

### ✅ GitHub Actions

Every pull request automatically runs:

- SwiftFormat in `--dryrun` mode to verify formatting
- Status check appears on PR to block merge if unformatted files are detected

Workflow file:

```
.github/workflows/format-check.yml
```

---

## 📈 Future CI/CD Integrations

- [ ] Full CI pipeline: lint → test → format → build → deploy
- [ ] Fastlane integration for builds and reports
- [ ] Artifacts and test coverage reporting
- [ ] TestFlight distribution on merge to `main` or `release/*`
