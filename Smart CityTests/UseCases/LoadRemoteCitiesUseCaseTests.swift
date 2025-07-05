//
//  LoadRemoteCitiesUseCaseTests.swift
//  Smart City
//
//  Created by Lugardo on 05/07/25.
//
import XCTest
@testable import Smart_City

final class LoadRemoteCitiesUseCaseTests: XCTestCase {
    private var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        decoder = JSONDecoder()
    }

    func testLoadRemoteCitiesWritesToRepository() async throws {
        // MARK: – Arrange

        // 1. Carga el JSON desde Fixtures/cities.json
        let bundle = Bundle(for: LoadRemoteCitiesUseCaseTests.self)
        let url = bundle.url(forResource: "cities", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let fixtureCities = try decoder.decode([City].self, from: data)

        // 2. Prepara el stub que devolverá ese array
        let remoteStub = StubCityRemoteDataSource(cities: fixtureCities)

        // 3. Usa tu repositorio real en memoria
        let repository = InMemoryCityRepository()

        // 4. Instancia el UseCase de producción
        //    Ajusta los parámetros de init según tu implementación real
        
        let useCase = DefaultLoadRemoteCitiesUseCase(repository: repository)
        
        // MARK: – Act
        try await useCase.execute()

        // MARK: – Assert
        let stored = repository.getCitites()
        XCTAssertEqual(stored, fixtureCities,
                       "Las ciudades cargadas en el repositorio deben coincidir con el fixture")
    }
}
