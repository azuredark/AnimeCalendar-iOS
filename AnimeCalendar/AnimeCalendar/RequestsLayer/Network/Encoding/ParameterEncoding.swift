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
    case errorPathEmpty             = "ACError - URL path is empty."
    case errorReference             = "ACError - Error accessing scope's reference."
    case errorCreatingUrlComponents = "ACError - Can't create URLComponents."
    case errorTest                  = "ACError - Error for testing purposes."
    case errorHttpCode              = "ACError - HTTP Code is not successful."
}
