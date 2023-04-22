//
//  MangaEndpoint.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

enum MangaEndpoint {
    case getManga(name: String)
    case getMangas
}

extension MangaEndpoint: EndpointType {
    var basePath: String {
        return API.getAPI(.v4)
    }
  
    var httpMethod: HTTPMethod {
        switch self {
            case .getManga(_), .getMangas:
                return .get
        }
    }
  
    var task: HTTPTask {
        switch self {
            case .getManga(let name):
                return .requestParameters(bodyParameters: nil, urlParameters:
                    ["q": name])
            case .getMangas:
                return .request
        }
    }
  
    var headers: HTTPHeaders? { nil }
    
    var retries: Int { 3 }
    
    var timeOut: CGFloat { 5.0 }
}
