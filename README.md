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
- **Map**: MapKit (to be integrated)
- **Testing**: XCTest, UI Tests (planned)

---

## 🗂 Project Structure

```
Smart_City
│
├── App/
│   ├── AppCoordinator.swift
│   ├── AppRoute.swift
│   ├── RootView.swift
│   └── Smart_CityApp.swift
│
├── Common/
│   └── Extensions/
│       ├── Device+Extensions.swift
│       ├── String+Extensions.swift
│       └── View+Modifiers.swift
│
├── Data/
│   ├── Persistence/
│   │   ├── CityEntity.swift
│   │   ├── ModelContext+Cities.swift
│   │   └── SwiftDataCityRepository.swift
│   │
│   ├── Repositories/
│   │   ├── City/
│   │   │   ├── CityRepository.swift
│   │   │   ├── InMemoryCityRepository.swift
│   │   │   └── SwiftDataFavoritesRepository.swift
│   │   │
│   │   ├── CitySummary/
│   │   │   ├── CitySummaryRepository.swift
│   │   │   └── DefaultCitySummaryRepository.swift
│   │   │
│   │   └── Favorites/
│   │       └── FavoritesRepository.swift
│   │
│   └── Services/
│       ├── CityRemoteDataSource.swift
│       └── WikipediaRemoteDataSource.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── City.swift
│   │   ├── City+Extensions.swift
│   │   └── WikiCitySummary.swift
│   │
│   └── UseCases/
│       ├── FetchCitySummaryUseCase.swift
│       ├── LoadRemoteCitiesUseCase.swift
│       ├── SearchCitiesUseCase.swift
│       └── ToggleFavoriteCityUseCase.swift
│
├── Features/
│   └── CitySearch/
│       ├── View/
│       │   ├── Detail/
│       │   │   ├── CityDetailView.swift
│       │   │   └── CityInfoCard.swift
│       │   │
│       │   └── Search/
│       │       ├── CitySearchView.swift
│       │       └── SearchRowView.swift
│       │
│       └── ViewModels/
│           ├── CityDetailViewModel.swift
│           └── CitySearchViewModel.swift
│
├── Network/
│   ├── Protocols/
│   ├── Models/
│   └── Implementations/
│
├── Resources/
│   └── Assets.xcassets
│
├── Smart_CityTests/
└── Smart_CityUITests/
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
- [x] UI adaptable to orientation (WIP with SplitView).
- [x] Interactive map view (✅)
- [ ] Unit and integration testing (coming soon)

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

## 📦 Delivery Plan

1. ✅ Base structure and README.
2. ✅ Search optimization and JSON fetch.
3. ✅ SwiftData integration and favorites logic.
4. ✅ Map interface and orientation support.
5. 🔜 Final metrics, testing, and polish.

---


## 📈 Product Success Observability

To ensure the success and usability of the **Smart City** feature, the following **key metrics** will be tracked:

### ✅ Key Metrics

- ⏱️ **Search performance time** – Track how long it takes to get search results.
- ❤️ **Number of favorited cities** – Understand user engagement with the feature.
- 🌍 **Most searched countries** – Identify geographic interest and patterns.
- 📊 **Session duration** – Measure how long users interact with the feature.
- 🔄 **Interaction events** – Monitor taps, navigation, and usage flow.


---

## 📬 Contact

For questions or feedback:
- 📩 iOS: jclugardo@icloud.com

_Developed by **Juan Carlos Lugardo** as part of the recruitment process for Ualá's Mobile Technical Lead position._
