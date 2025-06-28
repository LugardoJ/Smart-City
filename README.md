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
- **Persistence**: Initially InMemory
- **Map**: MapKit (to be integrated)
- **Testing**: XCTest, Testables (to be added)

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
├── Data/
│   └── Repositories/
│       ├── CityRepository.swift
│       └── InMemoryCityRepository.swift
│
├── Domain/
│   ├── Entities/
│   │   └── City.swift
│   └── UseCases/
│       ├── LoadRemoteCitiesUseCase.swift
│       ├── SearchCitiesUseCase.swift
│       └── ToggleFavoriteCityUseCase.swift
│
├── Features/
│   └── CitySearch/
│       ├── View/
│       │   ├── CityDetailView.swift
│       │   └── CitySearchView.swift
│       └── ViewModels/
│           └── CitySearchViewModel.swift
│
├── Framework/
│   └── Services/
│       └── CityRemoteDataSource.swift
│
├── Resources/
│   └── Assets.xcassets
│
├── Tests/
│   └── (Under Construction)
│
└── README.md
```

---

## ⚙️ Planned Features

- [x] Modular and coordinated structure
- [x] `City` entity modeling with custom ID (`_id`)
- [x] Initial dependency injection with protocols
- [/] Remote JSON loading of cities (~200k)
- [/] Prefix-based optimized search
- [ ] Reactive UI with SwiftUI
- [ ] Favorites persistence
- [ ] Interactive map view (coming soon)
- [ ] Unit and integration testing

---

## 🌐 Data Source

City data is fetched from the following JSON:

🔗 [Gist JSON (~200k cities)](https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json)

---

## 🧪 Testing Plan (Pending)

- [ ] Unit tests for `SearchCitiesUseCase`
- [ ] Mocked `CityRepository`
- [ ] ViewModel tests
- [ ] UI search tests

---

## 📦 Delivery Plan

1. ✅ Commit 1 – Base structure, architecture, and initial README  
2. ✅ Commit 2 – Data loading and real search implementation  
3. 🔜 Commit 3 – Favorites and persistence  
4. 🔜 Commit 4 – Map integration and visual improvements  
5. 🔜 Commit 5 – Metrics, testing, and final tweaks  

---

## 📊 Key Metrics (To Implement)

- Search response time
- Favorite city event tracking
- Most searched cities
- Session duration on map view

---

## 📬 Contact

For technical questions:
- iOS: jclugardo@icloud.com

_Developed by Juan Carlos Lugardo as part of the selection process for the Mobile Technical Lead role._
