# 📊 Observability & Metrics – Smart City

This document describes how the Smart City app collects, stores, and reports user behavior and performance metrics using a modular and extensible observability system.

---

## 🔍 Why Amplitude instead of Firebase?

While Firebase Analytics is a popular choice for iOS apps, **Amplitude** was selected for this project due to the following key advantages:

- ✅ **Event-level granularity** with flexible properties and schema validation
- ✅ **Real-time segmentation and dashboards** for product and business teams
- ✅ **Behavioral analytics** (funnels, cohorts, retention) out of the box
- ✅ **Client-side + server-side support**, with unified identity tracking
- ✅ **Robust developer tooling** (event schema explorer, debugger, versioning)
- ✅ Better alignment with **data-driven product workflows** and experimentation
- ✅ GDPR and SOC2 compliance features ready for production-scale apps

For local development and offline usage, Amplitude is wrapped with a decorator (`AmplitudeMetricsAdapter`) that also persists data using SwiftData.

---

## 🎯 Goals

- Measure feature usage and success
- Track user engagement (searches, visits, favorites)
- Capture performance data (search latency, load time)
- Enable real-time and historical insights (Amplitude + SwiftData)
- Maintain modularity and testability

---

## 🧩 Architecture Overview

Metrics are handled using two core protocols:

```swift
public protocol MetricsRecording {
    func recordSearchTerm(_ term: String)
    func recordCityVisit(cityId: Int)
    func recordLoadTime(source: String, duration: TimeInterval)
    func recordSearchLatency(query: String, duration: TimeInterval)
}
```

```swift
public protocol MetricsQuerying {
    func fetchTopSearchTerms(limit: Int) -> [String]
    func fetchTopVisitedCities(limit: Int) -> [(Int, Int)]
    func fetchAverageLoadTime() -> TimeInterval
}
```

---

## 🧠 Key Classes

| Component | Role |
|----------|------|
| `AmplitudeMetricsAdapter` | Implements `MetricsRecording`. Forwards data to Amplitude and SwiftData. |
| `SwiftDataMetricsRepository` | Implements `MetricsQuerying`. Queries local data from SwiftData entities. |
| `MetricsDashboardViewModel` | Uses query use cases to feed data to UI: top terms, most visited, latency, etc. |
| `MetricsDashboardView` | Displays dashboard metrics to user (or for dev inspection). |

---

## 🧾 Stored Metrics

| Entity | Description |
|--------|-------------|
| `SearchMetricEntity` | Records each search term + timestamp |
| `VisitMetricEntity` | Records each city visit + timestamp |
| `LoadTimeEntity` | Records screen load time and origin |
| `SearchLatencyEntity` | Tracks time between query input and result display |

All of these are stored locally using `SwiftData`, and optionally sent to Amplitude for centralized analytics.

---

## 🔀 Flow Overview

```text
UI Events (search, load, visit)
        |
        v
  UseCase Layer:
  - RecordSearchTermUC
  - RecordLoadTimeUC
  - RecordCityVisitUC
  - RecordSearchLatencyUC
        |
        v
  MetricsRecording (protocol)
        |
        v
  AmplitudeMetricsAdapter
     ↙            ↘
 SwiftDataRepo   AmplitudeSDK
```

---

## 📊 Dashboard Queries

Dashboard data is powered by `MetricsQuerying`:

- `fetchTopSearchTerms(limit:)`
- `fetchTopVisitedCities(limit:)`
- `fetchAverageLoadTime()`

These are used in `MetricsDashboardViewModel` and rendered in `MetricsDashboardView`.

---

## ✅ Observability Outcomes

This metrics system allows:

- Real-time feedback loop via Amplitude
- Offline data persistence via SwiftData
- Seamless testing with mock adapters
- Visual feedback via in-app dashboard

---

### 🎥 Metrics Dashboard

▶️ [Watch: Metrics overview](vid/Metrics.mp4) – Demonstrates `MetricsDashboardView` with real-time usage statistics
