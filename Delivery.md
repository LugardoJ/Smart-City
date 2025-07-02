### 📦 `Delivery.md` – Deployment & Quality Pipeline

Este archivo describe cómo se garantiza la **calidad del código** en el proyecto **Smart City** utilizando herramientas de análisis estático.  
Actualmente, no se incluye una integración de CI/CD completa, pero se sientan las bases para implementarla fácilmente.

---

## ✅ Code Quality Guardrails – SwiftLint

Para asegurar la consistencia del código y buenas prácticas, se integró **SwiftLint** como linter principal del proyecto.

### 🛠 Configuración actual

- Archivo de configuración: `.swiftlint.yml`
- Ejecutable: `run-swiftlint.sh`
- Integración: fase de *Build Phase* en Xcode
- Logs:  
  - 🟢 `Logs/Main/`: todos los resultados  
  - 🔴 `Logs/Errors/`: solo errores  
  - 🟡 `Logs/Warnings/`: solo advertencias  
  - 📊 `Logs/summary-latest.json`: resumen automático

### 📂 Carpetas incluidas en el análisis

```yaml
included:
  - "Smart City"
  - "Smart CityTests"
  - "Smart CityUITests"
```

### 🧹 Reglas activadas

- Reglas activadas por defecto
- Reglas adicionales como:  
  `explicit_init`, `unused_import`, `closure_spacing`, `joined_default_parameter`, `force_unwrapping`, `sorted_imports`

### ⚠️ Límite de complejidad y tamaño

```yaml
function_body_length:
  warning: 40
  error: 80

cyclomatic_complexity:
  warning: 10
  error: 15
```

### ▶️ Cómo ejecutarlo manualmente

Desde la raíz del proyecto:

```bash
bash run-swiftlint.sh
```

---

## 📈 Futuras integraciones

- [ ] CI/CD usando GitHub Actions o Bitrise
- [ ] Fastlane para validación local y automatización
- [ ] Exportación de reportes a formatos compatibles con CI