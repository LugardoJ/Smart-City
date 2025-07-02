//
//  Models.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

enum NetworkRequestType: String {
    case GET
    case POST
    case PUT
}
struct NetworkRequest {
    let url: URL
    let method: NetworkRequestType
    let headers: [String: String]
    
    init(url: URL,method: NetworkRequestType = .GET, headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}
