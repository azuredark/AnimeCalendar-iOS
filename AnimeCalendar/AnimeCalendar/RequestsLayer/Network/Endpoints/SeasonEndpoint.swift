//
//  SeasonEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/11/22.
//

import Foundation

// https://api.jikan.moe/v4/seasons/now?page=1
enum SeasonEndpoint: Equatable {
    case getCurrentSeasonAnime(page: Int)
    
    static func == (lhs: SeasonEndpoint, rhs: SeasonEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getCurrentSeasonAnime, .getCurrentSeasonAnime): return true
        }
    }
}

extension SeasonEndpoint: EndpointType {
    var service: String { "/seasons" }

    var basePath: String {
        switch self {
            case .getCurrentSeasonAnime:
                return API.getAPI(.v4) + service + "/now"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .getCurrentSeasonAnime:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .getCurrentSeasonAnime(let page):
                return .requestParameters(
                    bodyParameters: nil,
                    urlParameters: ["page": page])
        }
    }

    var headers: HTTPHeaders? { nil }
}
