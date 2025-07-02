//
//  City.swift
//  Smart City Exploration
//
//  Created by Lugardo on 27/06/25.
//

// MARK: - Model (Domain Layer)

public struct City: Identifiable, Codable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let country: String
    public let coord: Coordinate
    public var isFavorite: Bool

    public struct Coordinate: Codable, Equatable, Hashable {
        public let lon: Double
        public let lat: Double
    }

    public var coordinate: Coordinate { coord }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
        case isFavorite
    }

    public init(id: Int, name: String, country: String, coord: Coordinate, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.country = country
        self.coord = coord
        self.isFavorite = isFavorite
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        coord = try container.decode(City.Coordinate.self, forKey: .coord)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}
