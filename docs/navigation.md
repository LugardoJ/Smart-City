# 🧭 Navigation & Routing – Smart City

This document explains the navigation architecture of the Smart City iOS app, focusing on how user flow is managed across different device types (iPad vs iPhone), orientations (portrait vs landscape), and screen states using SwiftUI patterns.

---

## 📐 Strategy

Navigation is orchestrated using:

- `NavigationStack` (for compact devices like iPhone in portrait)
- `NavigationSplitView` (for iPad or wider screens)
- `CompactLandscapeView` (custom layout for iPhone in landscape mode)
- A centralized `AppCoordinator` that defines and drives route transitions.

---

## 📱 Entry Point Logic

### RootView.swift

```swift
Group {
    if UIDevice.isPad {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            CitySearchView(viewModel: viewModel)
        } detail: {
            navigationDetailContent
        }
    } else {
        CompactLandscapeView(viewModel: viewModel)
    }
}
```

- Devices that support split view (`isPad`) use `NavigationSplitView`.
- Compact devices fall back to a custom layout: `CompactLandscapeView`.

---

## 🧭 NavigationSplitView

### iPad Flow

```text
CitySearchView (sidebar)
        |
        v
CityDetailView (detail pane)
        |
        v
CityInfoCard (slide-up panel)

> 🧭 Additionally:
If the user opens the metrics dashboard:
- The `CityDetailView` pane is replaced by `MetricsDashboardView`
- The split layout persists, with search on the left and metrics on the right
```

- All views are visible simultaneously.
- Detail content is replaced when selecting a city.

---

## 📲 NavigationStack

### iPhone Portrait Flow

```text
CitySearchView
      ↓ tap city
CityDetailView
      ↓ tap "info"
CityInfoCard (overlay)

> 📊 Metrics:
When metrics are requested from the UI (e.g., tapping a button),
- The app pushes `MetricsDashboardView` onto the navigation stack
- This allows users to navigate back to `CitySearchView` as usual
```

- Uses `NavigationStack(path:)` with enums to define routes.
- Dynamic and type-safe with Swift enums.

---

## 📱 CompactLandscapeView

Custom layout used on iPhone landscape mode:

- Stacks search and detail horizontally
- Mimics split view on compact screens
- Adapts to orientation change using `UIDevice.orientationDidChangeNotification`

---

## 🧠 AppCoordinator

Manages:

- Navigation paths (`@Binding var path`)
- Route enum types (e.g. `.detail(city)`, `metricsDashboard`)
- Presentation logic (e.g. `sheet`, `fullScreenCover`)
- Root injection and setup

---

## 🔄 Navigation Flow Summary

```text
Smart_CityApp
    ↓
RootView
    ↓
[iPad] NavigationSplitView ─────→ CityDetailView
[iPhone Portrait] NavigationStack → CityDetailView (push)
[iPhone Landscape] CompactLandscapeView → dual pane
```

All flows use the same view models and state logic, ensuring consistency and testability.

---

## ✅ Summary

The navigation system is responsive, testable, and adapts seamlessly to screen size and orientation. Coordinators provide centralization, while SwiftUI patterns offer flexibility and clarity.


### 🎥 Navigation in Landscape

![](vid/LandscapeView.gif) – Shows `NavigationSplitView` adapting to horizontal orientation


