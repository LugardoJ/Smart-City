//
//  City.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//
// MARK: - Model (Domain Layer)

public struct City: Identifiable, Codable, Equatable,Hashable {
    public let id: Int
    public let name: String
    public let country: String
    public let coord: Coordinate

    public struct Coordinate: Codable, Equatable,Hashable {
        public let lon: Double
        public let lat: Double
    }

    public var coordinate: Coordinate { coord }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
    }
}
