//
//  PromoEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import Foundation

// https://api.jikan.moe/v4/watch/promos
enum PromoEndpoint: Equatable {
    case getRecentPromos(page: Int)
    
    static func == (lhs: PromoEndpoint, rhs: PromoEndpoint) -> Bool {
        switch (lhs, rhs) {
            case (.getRecentPromos, .getRecentPromos): return true
        }
    }
}

extension PromoEndpoint: EndpointType {
    var service: String { "/watch" }

    var basePath: String {
        switch self {
            case .getRecentPromos:
                return API.getAPI(.v4) + service + "/promos"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .getRecentPromos:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .getRecentPromos(let page):
                return .requestParameters(
                    bodyParameters: nil,
                    urlParameters: ["page": page])
        }
    }

    var headers: HTTPHeaders? { nil }
    
    var retries: Int { 3 }
}
