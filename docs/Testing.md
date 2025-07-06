# 🧪 TESTING.md – Smart City

This document outlines the testing strategy for the Smart City iOS app, covering unit tests, UI tests, use case validation, and repository mocking.

---

## ✅ Goals

- Ensure correctness of business logic
- Validate repository interactions and data persistence
- Confirm UI reflects expected states and data
- Prevent regressions via automated CI

---

## 🧠 Unit Testing Strategy

### 🔬 Scope

- **UseCases**: Validate core behavior (e.g. search, toggle favorite, fetch summary)
- **Repositories**: Test with mock data or in-memory stores
- **ViewModels**: Simulate input/output using test doubles

### ✅ Tools

- `XCTest` as the base framework
- Custom mocks and `InMemory*Repository` for isolation
- Fixtures via JSON (e.g. `cities.json` in `/Fixtures/`)

---

## 🧪 Unit Tests Example

```swift
func testToggleFavoriteMarksCityCorrectly() throws {
    let mockRepo = InMemoryFavoriteCityRepository()
    let useCase = DefaultToggleFavCityUseCase(repository: mockRepo)
    let city = City(id: 123, name: "Oslo", country: "NO", coord: .init(lat: 0, lon: 0), isFavorite: false)

    try useCase.execute(city: city)
    XCTAssertTrue(mockRepo.isFavorite(city.id))
}
```

---

## 🧭 ViewModel Testing

- Use dependency injection to test logic in `CitySearchViewModel`, `CityDetailViewModel`
- Inject `MockCoordinator` and test navigation triggers
- Validate changes to `results`, `favorites`, and metrics

---

## 📱 UI Testing

### ✅ What We Test

- Search interaction and debounce behavior
- Map rendering and detail tap
- Info button opens `CityInfoCard`
- Favorite toggling reflects in UI

### ✅ Tooling

- `XCUITest` for end-to-end UI tests
- Snapshot testing for selected screens (optional)

---

## 🧰 Continuous Integration

- All tests run automatically in GitHub Actions
- Coverage generated via `.xcresult`

---

## 📦 Testing Utilities

| Utility | Purpose |
|---------|---------|
| `InMemoryCityRepository` | Avoids I/O, simplifies testing |
| `MockToggleFavoriteCityUseCase` | Validates toggle logic |
| `MockCitySummaryRepository` | Avoids real HTTP requests |
| `MockAppCoordinator` | Validates navigation flow |

---


---

## 🗂️ Project Test Structure

The `Tests` folder is organized as follows:

### SmartCityTests

- `Fixtures/` – Static JSON like `cities.json`
- `Helpers/` – Utilities for assertions and mock building
- `Mocks/`
  - `Entities/` – `CitiesMocks`
  - `Navigation/` – `MockAppCoordinator`
  - `Repositories/` – e.g. `MockCityRepository`, `MockSearchHistoryRepository`, `MockMetricsQueryRepository`
  - `UseCases/` – e.g. `MockSearchCitiesUseCase`, `MockRecordSearchTermUseCase`, etc.

### Domain Tests

- `Repositories/City/` – `DefaultCitySummaryRepositoryTests`, `InMemoryCityRepositoryTests`
- `Repositories/UseCases/` – `FetchCitySummaryUseCaseTests`, `MetricsUseCasesTests`
- `ViewModels/City/` – `CitySearchViewModelTests`, `CityDetailViewModelTests`
- `ViewModels/Metrics/` – `MetricsDashboardViewModelTests`
- `Views/` – `CityInfoCardTests`

### SmartCityUITests

- `CityDetailUITests`
- `SearchFlowUITests`
- `MetricsDashboardUITests`
- `Smart_CityUITestsLaunchTests`

Each folder mirrors the actual app structure to keep logic isolated and testable.


## ✅ Summary

Testing in Smart City follows clean architecture and protocol-driven practices:

- Isolated, injectable dependencies
- Separation between logic and UI
- End-to-end flow validation via CI

This ensures reliability, confidence, and continuous improvement of the codebase.

