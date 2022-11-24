//
//  AnimeEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

// https://api.jikan.moe/v4/anime
enum AnimeEndpoint: Equatable {
    case getAnime(name: String)
    case getAnimes
    
    static func == (lhs: AnimeEndpoint, rhs: AnimeEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getAnime, getAnime): return true
            default: return false
        }
    }
}

extension AnimeEndpoint: EndpointType {
    var service: String { "/anime" }
    
    var basePath: String {
        return API.getAPI(.v4)+service
    }
  
    var httpMethod: HTTPMethod {
        switch self {
            case .getAnime, .getAnimes:
                return .get
        }
    }
  
    var task: HTTPTask {
        switch self {
            case .getAnime(let name):
                return .requestParameters(bodyParameters: nil, urlParameters:
                    ["q": name])
            case .getAnimes:
                return .request
        }
    }
  
    var headers: HTTPHeaders? { nil }
}
