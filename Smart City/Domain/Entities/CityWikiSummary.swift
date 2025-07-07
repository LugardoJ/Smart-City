//
//  CityWikiSummary.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

/// Lightweight summary information retrieved from Wikipedia for a given city.
///
/// Includes plain text extract and a thumbnail URL (if available).
public struct CityWikiSummary: Codable {
    public let title: String
    public let description: String?
    public let extract: String
    public let timestamp: String
    public let originalimage: WikiSummaryThumbnail?

    public init(
        title: String,
        description: String?,
        extract: String,
        timestamp: String,
        thumbnail: WikiSummaryThumbnail?
    ) {
        self.title = title
        self.description = description
        self.extract = extract
        self.timestamp = timestamp
        originalimage = thumbnail
    }

    public struct WikiSummaryThumbnail: Codable {
        public let source: String
        public let width: Int
        public let height: Int
    }
}
