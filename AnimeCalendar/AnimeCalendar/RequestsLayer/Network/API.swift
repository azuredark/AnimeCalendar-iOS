//
//  API.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

enum Environment {
    case production
    case develop
}

enum APIVersion: String {
    case v1, v2, v3, v4
}

enum API {
    // Default values
    private static var baseURL: String { "https://api.jikan.moe" }
    private static var version: APIVersion { .v4 }
    private static var environment: Environment { .develop }

    static func getAPI(_ version: APIVersion) -> String {
        switch environment {
            case .production, .develop:
                return "\(baseURL)/\(version.rawValue)"
        }
    }
    
    static func getAPI(_ version: APIVersion, _ environment: Environment) -> String {
        switch environment {
            case .production, .develop:
                return "\(baseURL)/\(version.rawValue)"
        }
    }

    static func getAPI() -> String {
        return "\(baseURL)/\(version.rawValue)"
    }
}
