# ❤️ FAVORITES.md – Smart City

This document outlines the implementation and persistence strategy for managing favorite cities in the Smart City app, using `CityEntity` and clean architecture principles.

---

## 💾 Data Model

Favorites are persisted directly inside the `CityEntity` SwiftData model:

```swift
@Model
final class CityEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var country: String
    var lon: Double
    var lat: Double
    var isFavorite: Bool
}
```

Instead of creating a separate entity (`FavoriteCityEntity`), we store the `isFavorite` flag within the city itself, allowing for:

- Simpler querying and filtering
- Direct mapping between storage and domain
- Single source of truth for favorite state

---

## 📦 Domain Model Mapping

The domain model `City` mirrors the structure of `CityEntity`, and the `isFavorite` state is maintained through the repository.

Mapping and synchronization are handled during initial SwiftData load.

---

## 🧠 Use Cases

| Use Case | Description |
|----------|-------------|
| `ToggleFavoriteCityUseCase` | Updates the `isFavorite` property in SwiftData |
| `FetchFavoriteCitiesUseCase` | Returns all cities where `isFavorite == true` |
| `MergePersistedFavoritesUseCase` | Syncs SwiftData values into memory (`InMemoryCityRepository`) |

---

## 🧱 Repository & Use Case Integration

Favorite operations are abstracted through the `FavoriteCityRepository` protocol.

- `DefaultFavoriteCityRepository` internally works with `CityEntity` and SwiftData
- `CityRepository` handles broader city operations (load, index, etc.)
- This separation keeps favorite toggling logic clean and isolated

The `ToggleFavoriteCityUseCase` uses `FavoriteCityRepository` as its dependency.

- `DefaultToggleFavCityUseCase` is injected into `CitySearchViewModel`
- This maintains a clean MVVM flow and supports testability

---

## 🧠 ViewModel Usage

ViewModels interact with favorites through:

- `CitySearchViewModel`:
  - Filters cities where `isFavorite == true`
  - Highlights favorite status in list rows
- `CityDetailViewModel`:
  - Triggers `ToggleFavoriteCityUseCase` from the `CityInfoCard` heart button

---

## ✅ UI Integration

- Favorite cities show a filled heart icon
- Toggling the star persists changes immediately via SwiftData
- The search view allows filtering to show only favorites

---

## 🧪 Testing Strategy

- Use `InMemoryCityRepository` to simulate favorite toggling
- Validate UI response to favorite state
- Preload test cities with `isFavorite` set to true in fixtures

---

## ✅ Summary

Smart City handles favorites using:

- A single unified `CityEntity` with an `isFavorite` flag
- SwiftData for persistence
- In-memory caching for performance
- ViewModels wired to toggle and display favorite state

This design avoids the need for a separate favorites structure and improves maintainability and consistency.

