//
//  NetworkManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

// https://api.jikan.moe/v4/anime
final class NetworkManager: Requestable {
    private lazy var router = Router()

    func makeRequest<T: Decodable>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) {
        let endpoint: EndpointType = getEndpoint(from: service)

        router.request(endpoint: endpoint) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            let httpResponse = strongSelf.handleHTTPResponse(response: response)

            if case .success = httpResponse, let data = data {
                guard let json = strongSelf.decodeData(model, from: data) else {
                    completion(.failure(JSONDecodingError.errorDecoding))
                    return
                }
                completion(.success(json))
            }

            if let error = error { completion(.failure(error)) }

            if case .failure(let msg) = httpResponse {
                print("senku [DEBUG] \(String(describing: type(of: self))) - ACError: \(msg)")
                // TODO: Handle failure message
//                completion(.failure(error))
            }
        }
    }

    // TODO: Could this be refacored in some way?? All cases return endpoint
    private func getEndpoint(from service: Service) -> EndpointType {
        switch service {
            case .anime(let endpoint):
                return endpoint
            case .manga(let endpoint):
                return endpoint
            case .user(let endpoint):
                return endpoint
        }
    }
}

private extension NetworkManager {
    func handleHTTPResponse(response: URLResponse?) -> ResponseCodeResult<String> {
        guard let code = (response as? HTTPURLResponse)?.statusCode else { return .noResponse }
        switch code {
            case 200 ... 299: return .success
            case 401 ... 500: return .failure(NetworkResponse.authenticationError.rawValue)
            case 501 ... 599: return .failure(NetworkResponse.badRequest.rawValue)
            case 600: return .failure(NetworkResponse.outdated.rawValue)
            default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func decodeData<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(type, from: data)
            return json
        } catch {
            print("senku [DEBUG] - error: \(error)")
            return nil
        }
    }
}

enum JSONDecodingError: String, Error {
    case errorDecoding
    case errorEncoding
}
