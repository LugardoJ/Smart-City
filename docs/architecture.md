
# 🧱 Architecture Overview

This document provides a full technical breakdown of the architecture for the **Smart City Exploration** feature. It maps real Swift classes and modules to the layers of **Clean Architecture**, while explaining their purpose, SOLID adherence, and runtime interactions.

---

## 📌 Summary

This architecture supports:

- ✅ Scalable feature expansion
- ✅ High-performance search and UI updates
- ✅ Real-time observability via Amplitude & SwiftData
- ✅ Full unit testing support with metrics included
- ✅ Seamless CI/CD integration

> See `/docs/img/architecture-diagram.png` for full system diagram.

---

## 📐 High-Level Diagram

Refer to `docs/img/architecture-diagram.png` for a visual overview of the app layers, from `Smart_CityApp` down to the data entities and remote sources.

![Architecture Diagram](img/architecture-diagram.png)

---


## 🧭 Layered Architecture Breakdown

The project follows **Clean Architecture**, applying **SOLID** principles. Layers communicate strictly through protocols, allowing testability and independent evolution.

---

### 1. 📱 **View Layer (SwiftUI)**

| File/Class | Role |
|------------|------|
| `Smart_CityApp.swift` | App entry point. Configures environment and root view. |
| `RootView.swift` | Responsible for layout adaptation: iPad uses `NavigationSplitView`, iPhone uses `CompactLandscapeView`. |
| `CitySearchView.swift` | Main search interface. Binds to `CitySearchViewModel`. |
| `CityDetailView.swift` | Shows selected city with map, favorite toggle, and summary. |
| `CityInfoCard.swift` | Subview that displays detailed information for a selected city. |
| `MetricsDashboardView.swift` | Dashboard interface for metrics like top searches, visits, and loading times. |

- Views are fully declarative.
- Bind directly to properties exposed by `@Observable` view models, leveraging Swift's Observation system.
- Trigger use case executions indirectly via ViewModel actions.

---

### 2. 🧠 **ViewModel Layer**

| File/Class | Role |
|------------|------|
| `CitySearchViewModel.swift` | Core UI logic: performs search, filtering, debounce, pagination. Injects multiple use cases. |
| `CityDetailViewModel.swift` | Manages city summary (Wikipedia), favorite status, and view tracking. |
| `MetricsDashboardViewModel.swift` | Handles retrieval and formatting of metric data using `MetricsQuerying`. Formats top N values and prepares data for visualization. |

- All dependencies are injected via initializers.
- Publishes to SwiftUI via `@Observable` view models, properties.
- Fully testable with mock UseCases and Repositories.

---

### 3. ⚙️ **Use Case Layer**

| Use Case | Responsibility |
|----------|----------------|
| `SearchCitiesUseCase` | Performs prefix-based search across all cities. |
| `ToggleFavoriteCityUseCase` | Adds or removes a city from the favorites list. |
| `LoadRemoteCitiesUseCase` | Loads the cities.json file from a remote URL. |
| `RecordSearchTermUseCase` | Logs search query terms into SwiftData and Amplitude. |
| `RecordLoadTimeUseCase` | Logs how long it took to load or render a view. |
| `RecordCityVisitUseCase` | Logs when a user views a city's detail. |
| `FetchTopSearchedTermsUseCase` | Returns top N search terms from local metrics. |
| `FetchTopVisitedCitiesUseCase` | Returns most visited cities by count. |
| `FetchRecentSearchesUseCase` | Loads recent search queries for suggestion UI. |

Use cases:
- Contain **no business rules**, just orchestration logic.
- Are pure and independently testable.
- Follow the Dependency Inversion Principle (DIP).

---

### 4. 🗂 Repository Layer (Protocols)

| Protocol | Implementations |
|----------|-----------------|
| `CityRepository` | ✅ `InMemoryCityRepository` |
| `FavoriteCityRepository` | ✅ SwiftData-backed |
| `MetricsRecording` / `MetricsQuerying` | ✅ `AmplitudeMetricsAdapter` + SwiftData |
| `WikipediaCitySummaryRepository` | ✅ `DefaultWikipediaCitySummaryRepository` |

- Repositories abstract data access.
- All dependencies to them are via protocols.
- The `AmplitudeMetricsAdapter` serves as a decorator that logs both remotely (Amplitude) and locally (SwiftData).

---

### 5. 💾 Data Source Layer

| Source | Used for |
|--------|----------|
| `CityRemoteDataSource.swift` | Fetches 200K+ cities from remote JSON (gist). |
| `SwiftData (ModelContext)` | Stores favorites, metrics, recent searches. |
| `WikipediaRemoteDataSource` | Fetches summaries for selected cities. Used only in `CityDetailView`. Does not persist locally. |

#### ✅ SwiftData Entities:
- `FavoriteCityEntity`
- `SearchHistoryEntity`
- `SearchMetricEntity`
- `VisitMetricEntity`
- `LoadTimeEntity`

All model data is persistently stored using `@Model` entities and queried with `ModelContext`.

---

### 🔄 Entity Abstraction Note

Although SwiftData's `@Model` entities like `CityEntity` or `FavoriteCityEntity` are used for persistence, they are **never exposed directly to the ViewModels or Views**.

Instead, the app defines a domain model `City` that acts as an abstraction between the data layer and the UI/business logic.

This approach ensures:

- ✅ Decoupling the domain from SwiftData or any storage technology
- ✅ Easier testing (e.g. using `InMemoryCityRepository` with pure Swift structs)
- ✅ Long-term flexibility to switch to other storage engines (Realm, SQLite, CoreData)

---

## 🔁 Coordinator Pattern

The app uses a central **`AppCoordinator`** that manages navigation across the app:

- Uses `NavigationStack` on iPhone (portrait) , Use `CompactLandscapeView` on iPhone (landscape) , `NavigationSplitView` on iPad
- Dynamically manages presentation of `sheet`, `fullScreenCover`, or path-based transitions
- Uses `@Binding var path` and enums for route modeling

---

## 🔒 Dependency Injection

- Every ViewModel, UseCase, and Repository uses **constructor injection**
- No singletons or shared state
- Promotes testability and composability

---

## 🧪 Testability & Mocks

| Layer | Test Strategy |
|-------|---------------|
| ViewModels | ✅ Unit tested with mocks and fixture JSON |
| Use Cases | ✅ Independent tests using mock repositories |
| Repositories | ✅ `InMemoryCityRepository` for offline testing |
| SwiftData | 🧪 Abstracted behind protocols for mocks and previews |

---

## ✅ SOLID Compliance Summary

| Principle | Example |
|----------|---------|
| **S** – SRP | `SearchCitiesUseCase` only performs search. `RecordLoadTimeUseCase` only logs time. |
| **O** – Open/Closed | You can add new `CityRepository` types without modifying consumers. |
| **L** – Liskov | Mocks and in-memory repos substitute real ones safely. |
| **I** – ISP | Repos are split (`FavoriteCityRepository`, `MetricsQuerying`, etc). |
| **D** – DIP | ViewModels/UseCases depend on protocols, not concrete classes. |

---

## 🔍 Search Flow (Example)

This flow illustrates how a search term entered by the user propagates through the architecture, triggering logic and metrics.

```text
+-----------------------------+
|   TextField (search term)  |
+-----------------------------+
              |
              v
+-----------------------------+
| onChange(of: debouncedTerm)|
+-----------------------------+
              |
              v
+-----------------------------+
|   SearchCitiesUseCase      |
+-----------------------------+
              |
              v
+-----------------------------+
| CityRepository (in-memory) |
| + prefix index             |
+-----------------------------+
              |
              v
+-----------------------------+
| results / favorites / full |
+-----------------------------+
              |
              v
+-----------------------------+
| RecordSearchLatencyUseCase|
+-----------------------------+
```

- `debouncedTerm` is handled inside `CitySearchViewModel` via `.onChange(of:)` + `Task.detached`.
- Results are filtered and sliced, then published to the view.
- Latency is measured using `Date.now` and sent to `RecordSearchLatencyUseCase`.


---


### 🎥 From Search to Detail

▶️ [Watch: Search to Detail flow](vid/SearchDetailView.gif) – Shows the transition between `CitySearchView` and `CityDetailView`

