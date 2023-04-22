//
//  EndpointType.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

protocol EndpointType {
    var basePath: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var retries: Int { get }
    var timeOut: CGFloat { get }
}

extension EndpointType {
    var retries: Int { 0 }
}

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
    case unknown
}

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}
