# 🚀 Smart City – Reto Técnico para Mobile Technical Lead (iOS)

Este proyecto es una solución al reto técnico para la posición de **Mobile Technical Lead** en **Ualá**.  
El objetivo es permitir a los usuarios explorar y buscar ciudades usando un mapa interactivo, optimizando tanto la experiencia de usuario como la calidad de la base de código.

---

## 📌 Objetivo del Reto

Desarrollar una funcionalidad llamada **Smart City**, que permita:

- Búsqueda en tiempo real de ciudades (~200,000 registros).
- Interfaz de mapa interactiva.
- Marcado persistente de ciudades favoritas.
- Interfaz adaptativa según la orientación del dispositivo.
- Organización modular y escalable.
- Observabilidad clara y métricas.

---

## 🧱 Tecnología y Arquitectura

- **Lenguaje**: Swift 6.0
- **Framework**: SwiftUI + Combine
- **Arquitectura**: Clean Architecture + Principios SOLID
- **Patrones**: MVVM, Coordinador (Coordinator)
- **Persistencia**: SwiftData (local), InMemory (búsqueda/cache)
- **Mapa**: MapKit (ya integrado)
- **Pruebas**: XCTest, UI Tests (planeado)

---

## 🗂 Estructura del Proyecto

```
Smart_City
│
├── App/
│   ├── AppCoordinator.swift
│   ├── AppRoute.swift
│   ├── RootView.swift
│   └── Smart_CityApp.swift
│
├── Common/
│   └── Extensions/
│       ├── Device+Extensions.swift
│       ├── String+Extensions.swift
│       └── View+Modifiers.swift
│
├── Data/
│   ├── Persistence/
│   │   ├── CityEntity.swift
│   │   ├── ModelContext+Cities.swift
│   │   └── SwiftDataCityRepository.swift
│   │
│   ├── Repositories/
│   │   ├── City/
│   │   │   ├── CityRepository.swift
│   │   │   ├── InMemoryCityRepository.swift
│   │   │   └── SwiftDataFavoritesRepository.swift
│   │   │
│   │   ├── CitySummary/
│   │   │   ├── CitySummaryRepository.swift
│   │   │   └── DefaultCitySummaryRepository.swift
│   │   │
│   │   └── Favorites/
│   │       └── FavoritesRepository.swift
│   │
│   └── Services/
│       ├── CityRemoteDataSource.swift
│       └── WikipediaRemoteDataSource.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── City.swift
│   │   ├── City+Extensions.swift
│   │   └── WikiCitySummary.swift
│   │
│   └── UseCases/
│       ├── FetchCitySummaryUseCase.swift
│       ├── LoadRemoteCitiesUseCase.swift
│       ├── SearchCitiesUseCase.swift
│       └── ToggleFavoriteCityUseCase.swift
│
├── Features/
│   └── CitySearch/
│       ├── View/
│       │   ├── Detail/
│       │   │   ├── CityDetailView.swift
│       │   │   └── CityInfoCard.swift
│       │   │
│       │   └── Search/
│       │       ├── CitySearchView.swift
│       │       └── SearchRowView.swift
│       │
│       └── ViewModels/
│           ├── CityDetailViewModel.swift
│           └── CitySearchViewModel.swift
│
├── Network/
│   ├── Protocolos/
│   ├── Modelos/
│   └── Implementaciones/
│
├── Resources/
│   └── Assets.xcassets
│
├── Smart_CityTests/
└── Smart_CityUITests/
```

---

## ⚙️ Funcionalidades Completadas

- [x] Arquitectura modular y coordinada.
- [x] Modelado del dominio `City`.
- [x] Búsqueda en memoria optimizada por prefijo.
- [x] Carga remota de 200,000+ ciudades desde JSON.
- [x] Persistencia local con SwiftData.
- [x] UI reactiva con SwiftUI.
- [x] Marcado de favoritos persistente.
- [x] Indicadores visuales: banderas, país completo, estrella de favorito.
- [x] UI adaptable a la orientación (con SplitView).
- [x] Vista de mapa interactivo (✅)
- [ ] Tests unitarios y de integración (próximamente)

---

## 🌐 Fuente de Datos

La data de ciudades se obtiene desde el siguiente JSON:

🔗 [JSON de Ciudades (~200k registros)](https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json)

---

## 🧪 Plan de Testing

- [ ] Pruebas unitarias para casos de uso de búsqueda.
- [ ] Mock para `CityRepository`.
- [ ] Tests de ViewModel y snapshots de UI.
- [ ] Pruebas de persistencia con SwiftData.

---

## 📦 Plan de Entrega

1. ✅ Estructura base y README.
2. ✅ Optimización de búsqueda y carga de JSON.
3. ✅ Integración de SwiftData y favoritos.
4. ✅ Interfaz de mapa y soporte de orientación.
5. 🔜 Métricas, pruebas y pulido final.

---

## 📈 Observabilidad y Éxito del Producto

Para asegurar el éxito y la usabilidad de **Smart City**, se propone medir las siguientes métricas clave:

### ✅ Métricas Clave

- ⏱️ **Tiempo de búsqueda** – Tiempo desde que el usuario escribe hasta que ve resultados.
- ❤️ **Cantidad de ciudades marcadas como favoritas** – Mide el interés del usuario.
- 🌍 **Países más buscados** – Identifica tendencias geográficas.
- 📊 **Duración de sesión** – Tiempo de uso por sesión.
- 🔄 **Eventos de interacción** – Navegación, favoritos, vistas abiertas.

---

## 📬 Contacto

Para preguntas o feedback:
- 📩 iOS: jclugardo@icloud.com

_Desarrollado por **Juan Carlos Lugardo** como parte del proceso de selección para la posición de Mobile Technical Lead en Ualá._
