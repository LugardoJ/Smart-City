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
│   └── Smart_CityApp.swift
│
├── Common/
│   └── Extensions/
│       ├── String+Extensions.swift
│       └── View+Modifiers.swift
│
├── Data/
│   ├── Extensions/
│   ├── Persistence/
│   │   ├── CityEntity.swift
│   │   ├── ModelContext+Cities.swift
│   │   └── SwiftDataCityRepository.swift
│   └── Repositories/
│       ├── City/
│       │   ├── CityRepository.swift
│       │   ├── InMemoryCityRepository.swift
│       │   └── SwiftDataFavoritesRepository.swift
│       └── Favorites/
│           └── FavoritesRepository.swift
│
├── Domain/
│   ├── City/
│   │   ├── UseCases/
│   │   │   ├── LoadRemoteCitiesUseCase.swift
│   │   │   ├── SearchCitiesUseCase.swift
│   │   │   └── ToggleFavoriteCityUseCase.swift
│   │   └── Entities/
│   │       └── City.swift
│
├── Features/
│   └── CitySearch/
│       ├── View/
│       │   ├── CityDetailView.swift
│       │   ├── CitySearchView.swift
│       │   └── SearchRowView.swift
│       └── ViewModels/
│           └── CitySearchViewModel.swift
│
├── Network/
│   ├── Implementations/
│   │   └── CityRemoteDataSource.swift
│   ├── Models/
│   └── Protocols/
│
├── Resources/
│   └── Assets.xcassets
│
├── Smart_CityTests/
│
├── Smart_CityUITests/
│
├── README.md
└── CHANGELOG.md
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
- [ ] UI adaptable to orientation (WIP with SplitView).
- [ ] Interactive map view (coming soon)
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
4. 🔜 Map interface and orientation support.
5. 🔜 Final metrics, testing, and polish.

---

## 📊 Key Metrics (Planned)

- Search time performance.
- Number of favorited cities.
- Most searched countries.
- Session duration and interaction events.

---

## 📬 Contact

For questions or feedback:
- 📩 iOS: jclugardo@icloud.com

_Developed by **Juan Carlos Lugardo** as part of the recruitment process for Ualá's Mobile Technical Lead position._
