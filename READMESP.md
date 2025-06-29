# 🚀 Smart City – Mobile Technical Lead Challenge (iOS)

Este proyecto es una solución al desafío técnico para el rol de **Mobile Technical Lead** en **Ualá**.  
El objetivo es permitir a los usuarios explorar y buscar ciudades usando un mapa interactivo, optimizando tanto la experiencia de usuario como la calidad del código base.

---

## 📌 Objetivo del reto

Desarrollar una funcionalidad llamada **Smart City**, que permita:

- Búsqueda en tiempo real de ciudades (~200,000 registros).
- Interfaz interactiva con mapa.
- Marcado de ciudades favoritas persistentes.
- UI adaptativa según orientación.
- Organización modular y escalable.
- Observabilidad y métricas claras.

---

## 🧱 Tecnología y arquitectura

- **Lenguaje**: Swift 6.0
- **Framework**: SwiftUI + Combine
- **Arquitectura**: Clean Architecture + SOLID
- **Patrones**: MVVM, Coordinator
- **Persistencia**: InMemory inicialmente
- **Mapa**: MapKit (a integrar)
- **Testing**: XCTest, Testables (por añadir)

---

## 🗂 Estructura del proyecto

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
│   └── (En construcción)
│
└── README.md
```

---

## ⚙️ Funcionalidades planeadas

- [x] Estructura modular y coordinada
- [x] Modelado de entidad `City` con ID personalizado (`_id`)
- [x] Inyección de dependencias inicial con protocolos
- [X] Carga remota del JSON de ciudades (~200k)
- [X] Búsqueda sensible al texto (con optimización por prefijo)
- [ ] UI reactiva con SwiftUI
- [x] Persistencia de favoritos
- [ ] Vista de mapa interactivo (próximamente)
- [ ] Pruebas unitarias y de integración

---

## 🌐 Fuente de datos

Los datos de ciudades se obtienen desde el siguiente JSON:

🔗 [Gist JSON (~200k ciudades)](https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json)

---

## 🧪 Plan de pruebas (pendiente)

- [ ] Unit tests para `SearchCitiesUseCase`
- [ ] Mockeado de `CityRepository`
- [ ] Test de ViewModel
- [ ] UI test de búsqueda

---

## 📦 Plan de entregas

1. ✅ Commit 1 – Estructura base, arquitectura y README inicial  
2. ✅ Commit 2 – Implementación de carga y búsqueda con datos reales  
3. ✅ Commit 3 – Favoritos y persistencia  
4. 🔜 Commit 4 – Integración con mapa y mejora visual  
5. 🔜 Commit 5 – Métricas, testing y ajustes finales  

---

## 📊 Métricas clave (a instrumentar)

- Tiempo de respuesta del buscador
- Eventos de ciudad marcada como favorita
- Ciudades más buscadas
- Duración de sesión en vista de mapa

---

## 📬 Contacto

Para dudas técnicas:
- iOS: jclugardo@icloud.com

_Desarrollado por Juan Carlos Lugardo como parte del proceso para el rol de Mobile Technical Lead._
