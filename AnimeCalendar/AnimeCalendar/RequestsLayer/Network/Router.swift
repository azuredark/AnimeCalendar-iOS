//
//  Router.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation

typealias RequestResponse = (Data?, URLResponse?, Error?) -> Void

enum ResponseCodeResult<T: StringProtocol> {
    case success
    case failure(T)
    case noResponse
}

final class Router {
    private var task: URLSessionTask?

    /// Create a network request using an input Endpoint.
    /// - Parameter endpoint: Endpoint containing all information related to the request.
    /// - Parameter completion: Closure of type RequestResponse  which returns the output of the request
    func request(endpoint: EndpointType, completion: @escaping RequestResponse) {
        do {
            let httpSession = URLSession(configuration: .ephemeral)
            let httpRequest: URLRequest = try buildHttpRequest(endpoint: endpoint)
            print("senku [📡] \(String(describing: type(of: self))) - endpoint: \(httpRequest.url?.absoluteURL)")
            task = httpSession.dataTask(with: httpRequest) { data, response, error in
                if let error = error { completion(nil, nil, error) }
                if let data = data { completion(data, response, nil) }
            }
            task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }

    /// Create network request using an input URL. Should be used for images
    /// - Parameter url: URL to fetch data from.
    /// - Parameter completion: Closure of type RequestResponse which returns the output of the request
    func request(from url: URL, completion: @escaping RequestResponse) {
        let httpSession = URLSession(configuration: .default)
        let httpRequest = URLRequest(url: url)
        task = httpSession.dataTask(with: httpRequest) { data, response, error in
            if let error = error { completion(nil, nil, error) }
            if let data = data { completion(data, response, nil) }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}

private extension Router {
    /*
     Build HTTP Request component
     */
    func buildHttpRequest(endpoint: EndpointType) throws -> URLRequest {
        guard let url = URL(string: "\(endpoint.basePath)") else { fatalError("Couldn't decode URL") }
        var httpRequest = URLRequest(url: url)
        do {
            switch endpoint.task {
                case .request:
                    // Set default header
                    httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .requestParameters(let bodyParameters, let urlParameters):
                    try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &httpRequest)
                case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                    try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &httpRequest)
                    addAdditionalHeaders(additionalHeaders, request: &httpRequest)
            }
        } catch { throw error }
        return httpRequest
    }

    /*
     Call Encoders to add parameters to the HTTP Request
     */

    func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch { throw error }
    }

    /*
     Add additional headers if needed by the request nature
     */
    func addAdditionalHeaders(_ headers: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key, value) in headers {
            // Sould be add, and not set
            // request.setValue(value, forHTTPHeaderField: key)
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case errorFound = "Request error found"
}
