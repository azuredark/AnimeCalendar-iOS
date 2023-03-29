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
    case getUpcomingSeasonAnime(page: Int)

    static func == (lhs: SeasonEndpoint, rhs: SeasonEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getCurrentSeasonAnime, .getCurrentSeasonAnime): return true
            case (.getUpcomingSeasonAnime, .getUpcomingSeasonAnime): return true
            default: return false
        }
    }
}

extension SeasonEndpoint: EndpointType {
    var service: String { "/seasons" }

    var basePath: String {
        switch self {
            case .getCurrentSeasonAnime:
                return API.getAPI(.v4) + service + "/now"
            case .getUpcomingSeasonAnime:
                return API.getAPI(.v4) + service + "/upcoming"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .getCurrentSeasonAnime, .getUpcomingSeasonAnime:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .getCurrentSeasonAnime(let page),
                 .getUpcomingSeasonAnime(let page):
                return .requestParameters(
                    bodyParameters: nil,
                    urlParameters: ["page": page])
        }
    }

    var headers: HTTPHeaders? { nil }

    var retries: Int { 3 }
}
