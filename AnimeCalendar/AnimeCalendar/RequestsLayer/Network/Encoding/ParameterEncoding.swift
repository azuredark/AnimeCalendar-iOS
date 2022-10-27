//
//  ParameterEncoding.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 31/08/22.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum NetworkError: String, Error {
    case errorParametersNil         = "ACError - Parameters were nil."
    case errorEncodingFailed        = "ACError - Parameters encoding failed."
    case errorMissingURL            = "ACError - URL is nil."
    case errorCreatingUrlComponents = "ACError - Can't create URLComponents"
}
