
# 📐 Architecture Deep Dive

## 1. Layers & Responsibility

(UI) View  ⇄  ViewModel  ⇆  UseCases  ⇆  Repositories  ⇆  SwiftData / Remote


* **View / ViewModel** – SwiftUI + Combine, no lógica de negocio.  
* **Use Case** – orquesta reglas, una responsabilidad única.  
* **Repository** – abstrae la fuente de datos (SwiftData, Network).  
* **Data Source** – implementa llamadas a red / cache.  

## 2. Data-flow Diagram

```mermaid
graph TD
UI[CitySearchView] --> VM[CitySearchViewModel]
VM -->|debounced query| SearchUC[SearchCitiesUseCase]
SearchUC --> Repo[CityRepository]
Repo -->|Cache hit| SwiftData[(SwiftData)]
Repo -->|Cache miss| RemoteDS[CityRemoteDataSource]
RemoteDS --> Repo
Repo --> VM
VM --> UI


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
