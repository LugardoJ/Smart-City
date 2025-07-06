# 📦 App Modules Overview – Smart City

This document provides an overview of the modular structure of the Smart City application. Each module is designed to follow the Single Responsibility Principle (SRP), with a clear boundary between responsibilities.

---

## 🧱 Modular Design Philosophy

Each module contains:

- Independent `ViewModel` with injected `UseCases`
- Views (`SwiftUI`) that bind to `@Observable` ViewModels
- `UseCases` orchestrating domain logic
- Protocol-based `Repositories` for abstraction
- Optional `DataSources` (local, remote, in-memory)

---

## 📦 Module Breakdown

### 🔍 Search Module

| Component | Purpose |
|-----------|---------|
| `CitySearchView` | Displays a filtered list of cities (all or favorites), shows which are marked as favorites. |
| `CitySearchViewModel` | Handles query debounce, slicing, favorite sync, and metrics logging. |
| `SearchCitiesUseCase` | Core use case for filtered prefix search. |
| `RecordSearchTermUseCase` | Logs user input. |
| `RecordSearchLatencyUseCase` | Measures search performance. |
| `CityRepository` | Abstracted access to in-memory dataset. |

---

### 📌 Detail Module

| Component | Purpose |
|-----------|---------|
| `CityDetailView` | Displays the selected city with a map. Hosts the info button that presents `CityInfoCard`. |
| `CityDetailViewModel` | Manages favorite state, city summary, and view metrics. Injected into `CityInfoCard`. |
| `CityInfoCard` | Slide-up UI for detailed city info and favorite toggle. Receives `CityDetailViewModel` as input. |
| `WikipediaCitySummaryRepository` | Loads summary from Wikipedia API. |
| `RecordCityVisitUseCase` | Logs city views. |
| `ToggleFavoriteCityUseCase` | Marks or unmarks city as favorite. |
| `FavoriteCityRepository` | Manages persistence via SwiftData. |

---

### ❤️ Favorites Module

| Component | Purpose |
|-----------|---------|
| `FavoriteCityRepository` | CRUD for SwiftData-backed favorite cities |
| `mergeFavorites` | Injects persisted state into in-memory dataset |
| `ToggleFavoriteCityUseCase` | Shared use case across views |
| `CityEntity`, `FavoriteCityEntity` | Data persistence layer |

---

### 📊 Metrics Module

| Component | Purpose |
|-----------|---------|
| `MetricsDashboardView` | Displays metrics UI: top cities, terms, latency |
| `MetricsDashboardViewModel` | Fetches aggregated metrics and formats for display |
| `MetricsRecording` / `MetricsQuerying` | Dual protocols for write/read tracking |
| `AmplitudeMetricsAdapter` | Decorator for sending data to Amplitude and SwiftData |
| `FetchTopVisitedCitiesUseCase` | Queries top N visited cities |
| `FetchTopSearchedTermsUseCase` | Queries top N search terms |

---

### 📈 Recent Searches Module

| Component | Purpose |
|-----------|---------|
| `SearchHistoryEntity` | Stores recent terms in SwiftData |
| `FetchRecentSearchesUseCase` | Loads suggestions from history |
| `RecordSearchTermUseCase` | Also logs to recent queries |

---

### 🧭 Coordinator Module

| Component | Purpose |
|-----------|---------|
| `AppCoordinator` | Controls flow and navigation |
| `NavigationPath`, `NavigationStack`, `NavigationSplitView` | Device-based navigation structure |
| `Route enum` | Declarative route modeling |
| `CompactLandscapeView` | Custom split layout for iPhone in landscape mode |

---

## 🧪 Testing & Fixtures

- `InMemoryCityRepository` is used both in production and testing:
  - At runtime, it serves as the in-memory cache for cities loaded from SwiftData
  - It avoids expensive SwiftData queries by holding indexed and sorted results
  - In tests, it enables fully mockable and deterministic environments
- `cities.json` is loaded from `Fixtures/` for offline test scenarios
- UseCases and ViewModels are decoupled via protocols, making them easy to mock

---

## ✅ Summary

This modular setup ensures separation of concerns, reuse of core logic, and consistent architectural patterns across the app.

