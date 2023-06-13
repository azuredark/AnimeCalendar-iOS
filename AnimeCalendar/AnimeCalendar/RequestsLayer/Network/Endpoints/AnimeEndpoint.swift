//
//  AnimeEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

enum AnimeEndpoint: Equatable {
    case getAnime(name: String)
    case getAnimeById(id: Int)
    case getAnimes
    case getCharacters(animeId: Int)
    case getReviews(animeId: Int)
    case getAnimeRecommendations(animeId: Int)
    
    static func == (lhs: AnimeEndpoint, rhs: AnimeEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getAnime, .getAnime): return true
            case (.getAnimeById, .getAnimeById): return true
            case (.getAnimes, .getAnimes): return true
            case (.getCharacters, .getCharacters): return true
            case (.getReviews, .getReviews): return true
            case (.getAnimeRecommendations, .getAnimeRecommendations): return true
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
            case .getAnimeById(let id):
                return API.getAPI(.v4)+service+"/\(id)"
            case .getCharacters(let animeId):
                return API.getAPI(.v4)+service+"/\(animeId)/characters"
            case .getReviews(let animeId):
                return API.getAPI(.v4)+service+"/\(animeId)/reviews"
            case .getAnimeRecommendations(let animeId):
                return API.getAPI(.v4)+service+"/\(animeId)/recommendations"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .getAnime, .getAnimeById, .getAnimes, .getCharacters, .getReviews, .getAnimeRecommendations:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
            case .getAnime(let name):
                return .requestParameters(bodyParameters: nil, urlParameters: ["q": name])
            case .getAnimes, .getAnimeById, .getCharacters, .getReviews, .getAnimeRecommendations:
                return .request
        }
    }
    
    var headers: HTTPHeaders? { nil }
    
    var retries: Int { 5 }
    
    var timeOut: CGFloat {
        if case .getCharacters = self { return 5.0 }
        return 8.0
    }
}
