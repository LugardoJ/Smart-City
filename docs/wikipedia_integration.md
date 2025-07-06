# 📚 Wikipedia Integration – Smart City

This document describes the integration of Wikipedia summaries into the Smart City app using a repository-driven, clean architecture approach.

---

## 🌍 Goal

To enrich the city detail view with a short summary from Wikipedia, retrieved and cached for better user experience and performance.

---

## 🔌 Architecture Overview

Wikipedia summaries are fetched via the `WikipediaCitySummaryRepository` interface.

### ✅ Repository Responsibilities

| Method | Description |
|--------|-------------|
| `fetchSummary(for city: City) async throws -> String` | Retrieves a short description for the specified city |

---

## 🔧 Implementation Details

Implemented by: `DefaultWikipediaCitySummaryRepository`

- Uses a REST API endpoint:
  - Wikipedia REST summary: `https://en.wikipedia.org/api/rest_v1/page/summary/{city_name}`
- Normalizes city names before sending the request
- Uses `City.name` for title lookup
- Summary is cached per session in memory

---

## 🧠 Use Case

A dedicated use case wraps the repository call:

```swift
protocol FetchCitySummaryUseCase {
    func execute(city: City) async throws -> String
}
```

- Implemented as `DefaultFetchCitySummaryUseCase`
- Handles error fallback (e.g., empty summary or placeholder)

---

## 🧱 ViewModel Integration

Used in:

- `CityDetailViewModel`:
  - Calls `FetchCitySummaryUseCase` when expanding info card
- `CityInfoCard`:
  - Displays the summary string if available
  - Triggers loading only when user taps info

---

## 📦 Caching Strategy

- Wikipedia summaries and thumbnail images are **not cached** — neither in memory nor in persistent storage.
- Every time the user navigates to a city, a fresh request is made to Wikipedia.
- This decision prevents memory bloat and eliminates database growth risk from 200k+ entries.
- Trade-off: repeated requests for the same city may occur during the same session.

---

## ❌ Offline Behavior

- Wikipedia data is not persisted across sessions
- Offline users will not have access to summaries or images
- `CityInfoCard` displays a placeholder or "No summary available"
- Thumbnail images from Wikipedia are also not stored to minimize SwiftData size

---

## ✅ Summary

Wikipedia integration provides contextual information in a lightweight and dynamic way, fully aligned with Clean Architecture and respecting separation of concerns.

- Uses protocol-driven repositories
- Async fetch wrapped in use case
- Lazy-loaded in the UI
- Session-level caching avoids redundant calls
