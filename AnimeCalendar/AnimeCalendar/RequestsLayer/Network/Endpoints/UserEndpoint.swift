//
//  UserEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

enum UserEndpoint {
    case getUser(name: String)
}

extension UserEndpoint: EndpointType {
    var basePath: String {
        return API.getAPI(.v4)
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .getUser:
                return .get
        }
    }

    var task: HTTPTask {
        switch self {
            case .getUser(let name):
                return .requestParameters(bodyParameters: nil, urlParameters:
                    ["q": name])
        }
    }

    var headers: HTTPHeaders? { nil }
    
    var timeOut: CGFloat { 5.0 }
}
