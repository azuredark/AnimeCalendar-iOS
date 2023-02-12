//
//  AnimeEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

// https://api.jikan.moe/v4/anime
// https://api.jikan.moe/v4/anime/44511/characters
enum AnimeEndpoint: Equatable {
    case getAnime(name: String)
    case getAnimes
    case getCharacters(animeId: Int)
    
    static func == (lhs: AnimeEndpoint, rhs: AnimeEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getAnime, .getAnime): return true
            case (.getAnimes, .getAnimes): return true
            case (.getCharacters, .getCharacters): return true
            default: return false
        }
    }
}

extension AnimeEndpoint: EndpointType {
    var service: String { "/anime" }
    
    var basePath: String {
        switch self {
            case .getAnime, .getAnimes:
                return API.getAPI(.v4)+service
            case .getCharacters(let animeId):
                return API.getAPI(.v4)+service+"/\(animeId)/characters"
        }
    }
  
    var httpMethod: HTTPMethod {
        switch self {
            case .getAnime, .getAnimes, .getCharacters:
                return .get
        }
    }
  
    var task: HTTPTask {
        switch self {
            case .getAnime(let name):
                return .requestParameters(bodyParameters: nil, urlParameters:
                    ["q": name])
            case .getAnimes, .getCharacters:
                return .request
        }
    }
  
    var headers: HTTPHeaders? { nil }
}
