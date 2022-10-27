//
//  URLParameterEncoder.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 31/08/22.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    // MARK: - Send query parameters
    // Encode parameters dict. to send as request parameters
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.errorMissingURL
        }
        // Construct url query parameters
        guard !parameters.isEmpty else {
            throw NetworkError.errorParametersNil
        }
        // Construct url components structure
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.errorCreatingUrlComponents
        }
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            // Replaces not allowed characters
            let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            urlComponents.queryItems?.append(queryItem)
        }
        /// Update URL with new one that contains query items
        urlRequest.url = urlComponents.url
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
