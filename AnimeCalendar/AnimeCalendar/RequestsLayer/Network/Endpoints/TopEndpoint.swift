//
//  TopEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/11/22.
//

import Foundation

// https://api.jikan.moe/v4/top/anime?order_by=rank&page=1

enum TopEndpoint: Equatable {
    case getTopAnime(orderBy: AnimeOrderType, page: Int)

    static func == (lhs: TopEndpoint, rhs: TopEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getTopAnime, .getTopAnime): return true
        }
    }
}

extension TopEndpoint: EndpointType {
    var service: String { "/top" }

    var basePath: String {
        switch self {
            case .getTopAnime:
                return API.getAPI(.v4) + service + "/anime"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .getTopAnime:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .getTopAnime(let order, let page):
                return .requestParameters(
                    bodyParameters: nil,
                    urlParameters: ["order_by": order.rawValue,
//                                    "type": "tv",
                                    "page": page]
                )
        }
    }

    var headers: HTTPHeaders? { nil }
    
    var retries: Int { 3 }
}

enum AnimeOrderType: String {
    case rank
}
