
# 📦 Delivery Plan

This document outlines the key delivery milestones for **Smart City**.

---

## 1. Base & Architecture  
- Modular project structure (App, Common, Data, Domain, Features, Network)  
- MVVM + Coordinator pattern  
- Clean Architecture & SOLID principles  

## 2. Search & Remote Data  
- Load ~200K city records from JSON  
- Optimized in-memory prefix search  
- `CityRemoteDataSource` for network fetch  

## 3. Local Persistence & Favorites  
- **SwiftData** entities (`CityEntity`) for caching cities  
- `cacheCities()` and `fetchCachedCities()` extensions on `ModelContext`  
- Persistent favorites via `SwiftDataFavoritesRepository`  

## 4. MapKit & Adaptive UI  
- Detail view with MapKit integration  
- `NavigationSplitView` on iPad / large screens  
- `CompactLandscapeView` for iPhone:  
  - Portrait: push detail on stack  
  - Landscape: split layout with search + detail  

## 5. 📊 Metrics & Dashboard  
- **Capture** metrics:  
  - Page load time (network vs. local)  
  - Search latency  
  - Top search terms counts  
  - Top visited cities counts  
- **Persistence** via SwiftData entities:  
  - `LoadTimeMetricEntity`  
  - `SearchLatencyEntity`  
  - `SearchMetricEntity`  
  - `VisitMetricEntity`  
- **Visualization** in `MetricsDashboardView` with Swift Charts:  
  - `LineMark` for latencies  
  - `BarMark` for load times, searches, visits  
  - `SectorMark` for favorites-by-country  
- **Adapters**:  
  - `SwiftDataMetricsRecorder` + `AmplitudeMetricsAdapter` combined in `CompositeMetricsRecorder`  

## 6. 🧪 Testing & QA  
- Unit tests for UseCases & Repositories  
- UI tests for core user flows  
- Code quality guardrails:  
  - **SwiftLint** configuration & build-phase script  
  - **SwiftFormat** pre-commit hook & CI check  

## 7. 🚀 Rollout & Observability  
- CI/CD pipeline via GitHub Actions  
- Automatic linting, formatting, and test runs on PRs  
- Amplitude integration for production analytics  
- Dashboard for tracking key metrics post-release  
