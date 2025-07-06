//
//  LoadTime.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import Foundation

public struct LoadTime: Identifiable, Equatable {
    public let id = UUID()
    public let source: String
    public let duration: TimeInterval
    public let timestamp: Date
}
