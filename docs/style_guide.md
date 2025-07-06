# ✍️ Style Guide – Smart City

This document defines the coding standards, naming conventions, PR process, and Swift tooling rules for maintaining a clean and consistent codebase across the Smart City project.

---

## 🧱 Project Structure

- Group code by feature/module (e.g. Search, Detail, Metrics)
- Use folders to separate layers: `View`, `ViewModel`, `UseCase`, `Repository`, `DataSource`, `Model`
- Avoid dumping all files into a shared `Utils` or `Helpers` folder

---

## 🧠 Naming Conventions

| Element | Convention | Example |
|--------|------------|---------|
| Types (classes, structs, enums) | PascalCase | `CitySearchViewModel` |
| Functions / variables | camelCase | `searchCities()` |
| Constants | camelCase with `let` | `let pageSize = 20` |
| Files | Match main type name | `CityDetailView.swift` |
| Protocols | Descriptive, no "Protocol" suffix | `CityRepository`, `MetricsRecording` |
| ViewModels | End in `ViewModel` | `CityDetailViewModel` |

---

## 🧪 Testing Rules

- Mirror the production file structure
- Name test targets as `<Feature>Tests.swift`
- Use `XCTest` assertions
- Prefer protocol-based mocking and `InMemory` stubs
- Load test data from `/Fixtures/` (For this specific case, only for production performance tests)

---

## 🧹 SwiftLint Configuration

Smart City uses SwiftLint via `.swiftlint.yml` and a custom build phase script.

### 🔧 Configuration highlights:

- Enabled rules:
  - `explicit_init`
  - `force_unwrapping`
  - `unused_import`
  - `sorted_imports`
  - `closure_spacing`
- Analyzer rules and opt-in rules are enforced
- Violation thresholds:
  - `cyclomatic_complexity: 10`
  - `function_body_length: 100`
  - `identifier_name` includes minLength = 3
- Excludes:
  - `Smart CityTests/`
  - `Smart CityUITests/`
- Output logs to:
  - `Logs/Warnings/`, `Logs/Errors/`, `summary-latest.json`

To run manually:

```bash
bash run-swiftlint.sh
```

---

## 🧼 SwiftFormat Configuration

SwiftFormat is configured with `.swiftformat` and is enforced locally and via CI.

### 🔧 Configuration highlights:

- Swift version: `--swiftversion 6.0`
- Style:
  - `--allman false` (K&R style braces)
  - `--indent 4` (4-space indentation)
  - `--wraparguments before-first`
  - `--wrapelements before-first`
- Enabled rules:
  - `--enable redundantReturn`
  - `--enable redundantSelf`
  - `--enable sortImports`
  - `--enable spaceInsideParens`
- Argument cleanup:
  - `--stripunusedargs closure-only`
- Header: `--header ignore`
- Excludes:
  - `.build/`, `DerivedData/`

To format manually:

```bash
swiftformat .
```

---

## 🧾 Git & PR Guidelines

- Branches: `feature/*`, `fix/*`, `release/*`
- All PRs must:
  - Pass CI (lint, format, test)
  - Be reviewed by at least one maintainer
  - Include a descriptive title and body
- Commit messages should follow conventional format:

```bash
type(scope): emoji summary

# Example:
docs(readme): 📝 Add architecture diagram section
```

---

## ✅ Summary

This style guide ensures consistency and maintainability across the Smart City codebase, enforces quality through automation, and supports collaborative development workflows.
