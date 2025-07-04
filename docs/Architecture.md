# 🧱 Clean Architecture – Full Diagram

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
