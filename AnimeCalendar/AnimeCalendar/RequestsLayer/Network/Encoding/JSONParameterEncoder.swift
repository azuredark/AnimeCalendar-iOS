//
//  JSONParameterEncoder.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

struct JSONParameterEncoder {
  // MARK: - Send body
  // Encode parameters dict. to send as request body
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    do {
      // Dict. of parameters to data as request body
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      urlRequest.httpBody = jsonData
      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    } catch { throw NetworkError.errorEncodingFailed }
  }
}
