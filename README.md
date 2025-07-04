# 🚀 Smart City – Mobile Technical Lead Challenge (iOS)

This project is a solution to the technical challenge for the **Mobile Technical Lead** role at **Ualá**.  
The goal is to allow users to explore and search for cities using an interactive map, optimizing both the user experience and codebase quality.

---

## 📌 Challenge Objective

Develop a feature called **Smart City**, which enables:

- Real-time search of cities (~200,000 records).
- Interactive map interface.
- Persistent favorite cities marking.
- Adaptive UI based on orientation.
- Modular and scalable organization.
- Clear observability and metrics.

---

## 🧱 Technology and Architecture

- **Language**: Swift 6.0
- **Framework**: SwiftUI + Combine
- **Architecture**: Clean Architecture + SOLID
- **Patterns**: MVVM, Coordinator
- **Persistence**: SwiftData (local), InMemory (search/cache)
- **Map**: MapKit
- **CI/CD**: GitHub Actions
- **Linting**: SwiftLint + SwiftFormat
- **Testing**: XCTest, UI Tests (planned)

---

### 🧭 Architecture Diagram (Clean Architecture)

👉  For the full deep-dive, see [docs/architecture.md](docs/architecture.md)



```
  ### 🧭 High-Level Architecture
                        +----------------------+
                        |     Smart_CityApp    |
                        +----------------------+
                                  |
                                  v
                        +----------------------+
                        |       RootView       | ← NavigationSplitView
                        +----------------------+
                         |                   |
                         v                   v
        +--------------------------+   +---------------------------+
        |   CitySearchView.swift   |   |   CityDetailView.swift    |
        +--------------------------+   +---------------------------+
                  |                                ^
                  v                                |
    +-------------------------------+              |
    | CitySearchViewModel.swift     |--------------+
    +-------------------------------+
       |         |        |     |   |    \
       |         |        |     |    \--> RecordLoadTimeUseCase
       |         |        |     |
       |         |        |     +--> RecordSearchTermUseCase
       |         |        |
       |         |        +--> ToggleFavoriteUseCase
       |         |
       |         +--> SearchCitiesUseCase
       |
       +--> LoadRemoteCitiesUseCase
       |
       +--> FetchRecentSearchesUseCase
       |
       +--> FetchTopSearchedTermsUseCase
       +--> FetchTopVisitedCitiesUseCase
       +--> RecordCityVisitUseCase

       ├────────────┬────────────┬─────────────┐
       ↓            ↓            ↓             ↓
+----------------+ +------------------+ +------------------+ +----------------------+
| CityRepository | | FavoriteRepo     | | HistoryRepo      | | MetricsRepo          |
| (InMemory...)  | | (SwiftData)      | | (SwiftData)      | | (SwiftData)          |
+----------------+ +------------------+ +------------------+ +----------------------+
        |                    |                |                             |
        v                    |                |                             |
+-----------------------------+       +-----------------------------+   +---------------------------+
|  SwiftData (ModelContext)   |       |     SearchHistoryEntity     |   | + LoadTimeEntity          |
+-----------------------------+       |     VisitMetricEntity       |   | + VisitMetricEntity       |
        |                             |     SearchMetricEntity      |   |                           |
        |                             +-----------------------------+   +---------------------------+
        |
        |      
        v
+---------------------------+
| CityRemoteDataSource      |
+---------------------------+

         |
         v
+---------------------------+
| WikipediaRemoteDataSource | ← It is only used in CityDetailView
+---------------------------+   and does not save anything locally.
   
```

---


## 🗂 Project Structure

```
Smart City
│
├── App
│   ├── AppCoordinator.swift
│   ├── AppRoute.swift
│   ├── CompactLandscapeView.swift 
│   ├── RootView.swift
│   └── Smart_CityApp.swift
│
├── Common
│   └── Extensions
│       ├── Device+Extensions.swift
│       ├── String+Extensions.swift
│       └── View+Modifiers.swift
│
├── Data
│   ├── Persistence
│   │   ├── CityEntity.swift
│   │   ├── LoadTimeMetricEntity.swift
│   │   ├── SearchHistoryEntity.swift
│   │   ├── SearchLatencyEntity.swift
│   │   ├── SearchMetricEntity.swift
│   │   ├── VisitMetricEntity.swift
│   │   └── ModelContext+Cities.swift
│   │
│   └── Repositories
│       ├── City
│       │   ├── CityRepository.swift
│       │   ├── InMemoryCityRepository.swift
│       │   └── SwiftDataFavoritesRepository.swift
│       │
│       ├── Favorites
│       │   └── FavoritesRepository.swift
│       │
│       ├── History
│       │   ├── SearchHistoryRepository.swift
│       │   └── SwiftDataSearchHistoryRepo.swift
│       │
│       ├── Metrics
│       │   ├── AmplitudeMetricsAdapter.swift
│       │   ├── CompositeMetricsRecorder.swift
│       │   ├── MetricsRepository.swift
│       │   ├── SwiftDataMetricsRecorder.swift
│       │   └── SwiftDataMetricsQueryRepository.swift
│       │
│       └── Summary
│           ├── CitySummaryRepository.swift
│           └── DefaultCitySummaryRepository.swift
│
├── Domain
│   ├── Entities
│   │   ├── City.swift
│   │   ├── City+Extensions.swift
│   │   ├── CityWikiSummary.swift
│   │   ├── LoadTime.swift
│   │   └── SearchLatency.swift
│   │
│   └── UseCases
│       ├── City
│       │   ├── FetchCitySummaryUseCase.swift
│       │   ├── FetchRecentSearchesUseCase.swift
│       │   ├── LoadRemoteCitiesUseCase.swift
│       │   ├── SearchCitiesUseCase.swift
│       │   └── ToggleFavoriteCityUseCase.swift
│       │
│       ├── History
│       │   └── DefaultRecordSearchMetricUseCase.swift
│       │
│       └── Metrics
│           ├── FetchLoadTimeUseCase.swift
│           ├── FetchSearchLatenciesUseCase.swift
│           ├── FetchTopSearchTermsUseCase.swift
│           ├── FetchTopVisitedCitiesUseCase.swift
│           ├── RecordCityVisitUseCase.swift
│           └── RecordLoadTimeUseCase.swift
│
├── Features
│   └── CitySearch
│       ├── Enums
│       │   └── CityFilterType.swift
│       │
│       ├── View
│       │   ├── Detail
│       │   │   ├── CityDetailView.swift
│       │   │   └── CityInfoCard.swift
│       │   │
│       │   └── Search
│       │       ├── CitySearchView.swift
│       │       ├── SearchFavoriteListView.swift
│       │       └── SearchRowView.swift
│       │
│       ├── ViewModels
│       │   ├── CityDetailViewModel.swift
│       │   └── CitySearchViewModel.swift
│       │
│       └── Metrics                      
│           ├── View
│           │   └── MetricsDashboardView.swift
│           │
│           └── ViewModels
│               └── MetricsDashboardViewModel.swift
│
├── Network
│   ├── Protocols
│   ├── Models
│   └── Implementations
│       ├── CityRemoteDataSource.swift
│       ├── SessionRequest.swift
│       └── WikipediaRemoteDataSource.swift
│
├── Resources
│   └── Assets.xcassets
│
├── Smart_CityTests
└── Smart_CityUITests

```

---

## ⚙️ Completed Features

- [x] Modular and coordinated architecture.
- [x] `City` domain modeling.
- [x] InMemory search with index-based optimization.
- [x] Remote fetch of 200K+ cities from JSON.
- [x] Local persistence of cities using SwiftData.
- [x] Prefix-based optimized search
- [x] Reactive UI with SwiftUI
- [x] Favorites saved locally (SwiftData).
- [x] Visual indicators: country flags, full country names, favorite stars.
- [x] Interactive map view (✅)
+ [x] 📊 **Metrics dashboard**: load time, search latency, top searches & visits
+ [x] 📱 **CompactLandscapeView** for iPhone (portrait push / landscape split)
- [ ] Unit and integration testing (In progress)


---

## 🌐 Data Source

City data is fetched from the following JSON:

🔗 [Cities JSON (~200k records)](https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json)

---

## 🧪 Testing Plan

- [ ] Unit tests for search use cases.
- [ ] Mock `CityRepository`.
- [ ] ViewModel and UI snapshot tests.
- [ ] Test SwiftData favorite persistence.

---

## 📈 Product Success Observability

To ensure the success and usability of the **Smart City** feature, the following **key metrics** will be tracked:

### ✅ Key Metrics (IN PROGRESS)

- ⏱️ **Search performance time** – Track how long it takes to get search results.
- ❤️ **Number of favorited cities** – Understand user engagement with the feature.
- 🌍 **Most searched cities** – Identify geographic interest and patterns.
- 📊 **Session duration** – Measure how long users interact with the feature.
- 🔄 **Interaction events** – Monitor taps, navigation, and usage flow.

---

## 🧪 Code Quality Guardrails

This project integrates **SwiftLint** as a build phase to ensure code quality and maintainability.  
Custom `.swiftlint.yml` includes opt-in rules, analyzer rules, and logs are output to:

- `Logs/Main/` – Full logs.
- `Logs/Errors/` – Errors only.
- `Logs/Warnings/` – Warnings only.
- `summary-latest.json` – Summary for fast CI parsing.

SwiftLint is automatically executed on build via a `run-swiftlint.sh` script.

---

### 🧰 Installing SwiftLint on macOS

If you're using a Mac with Homebrew, you can install SwiftLint with:

```bash
brew install swiftlint
```

Then verify your installation:

```bash
swiftlint version
```

To manually run the analysis and view the logs:

```bash
bash run-swiftlint.sh
```

> 💡 The script performs automatic style corrections (`autocorrect --format`) and splits the results by type to facilitate analysis.

---

## 🧹 Code Formatting – SwiftFormat

This project uses [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to ensure a consistent and clean Swift codebase across all contributors.

### ✅ What's included

- `.swiftformat` configuration file at project root
- Project-wide formatting applied via `swiftformat .`
- `pre-commit` Git hook to auto-format code before every commit
- GitHub Actions workflow to validate formatting on every pull request

---

### 🛠 Installation (macOS)

Install SwiftFormat globally via Homebrew:

```bash
brew install swiftformat
```

Or update:

```bash
brew upgrade swiftformat
```

Verify installation:

```bash
swiftformat --version
```

---

### 🧪 Manual formatting

You can manually format the codebase at any time by running:

```bash
swiftformat .
```

This will apply the rules defined in `.swiftformat`.

---

### 🧾 Pre-commit automation

A Git `pre-commit` hook is included to automatically run SwiftFormat before each commit.  
To enable it manually (if not already active):

```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

This ensures that any staged Swift files are formatted before being committed.

---

### 🚦 CI Integration

Every pull request triggers a GitHub Actions workflow that runs SwiftFormat in dry-run mode.  
If any file is not properly formatted, the PR check will fail.

Workflow file:
```
.github/workflows/CI.yml
```

---

### ⚠️ Note

SwiftFormat applies **non-functional changes only** (spacing, indentation, wrapping, import sorting, etc.).  
It does **not affect logic or business functionality**.

---

## 📬 Contact

For questions or feedback:
- 📩 iOS: jclugardo@icloud.com

_Developed by **Juan Carlos Lugardo** as part of the recruitment process for Ualá's Mobile Technical Lead position._
