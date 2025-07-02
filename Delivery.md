### 📦 `Delivery.md` – Deployment & Quality Pipeline

This document outlines how **code quality** is ensured in the **Smart City** project using static analysis tools.  
Currently, there is no full CI/CD integration, but the foundation is set to easily implement it.

---

## ✅ Code Quality Guardrails – SwiftLint

To ensure code consistency and best practices, **SwiftLint** has been integrated as the project's primary linter.

### 🛠 Current Configuration

- Configuration file: `.swiftlint.yml`
- Executable: `run-swiftlint.sh`
- Integration: *Build Phase* in Xcode
- Logs:  
  - 🟢 `Logs/Main/`: all results  
  - 🔴 `Logs/Errors/`: only errors  
  - 🟡 `Logs/Warnings/`: only warnings  
  - 📊 `Logs/summary-latest.json`: automatic summary

### 📂 Folders Included in Analysis

```yaml
included:
  - "Smart City"
  - "Smart CityTests"
  - "Smart CityUITests"
```

### 🧹 Enabled Rules

- Default enabled rules
- Additional rules such as:  
  `explicit_init`, `unused_import`, `closure_spacing`, `joined_default_parameter`, `force_unwrapping`, `sorted_imports`

### ⚠️ Complexity and Size Limits

```yaml
function_body_length:
  warning: 40
  error: 80

cyclomatic_complexity:
  warning: 10
  error: 15
```

### ▶️ How to Run It Manually

From the root of the project:

```bash
bash run-swiftlint.sh
```

---

## 📈 Future Integrations

- [ ] CI/CD using GitHub Actions or Bitrise  
- [ ] Fastlane for local validation and automation  
- [ ] Export reports to CI-compatible formats
