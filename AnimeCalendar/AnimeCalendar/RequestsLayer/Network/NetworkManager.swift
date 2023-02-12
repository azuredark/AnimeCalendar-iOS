//
//  NetworkManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class NetworkManager: Requestable {
    // MARK: State
    /// # Router
    private lazy var router = Router()

    // MARK: Methods
    func makeRequest<T: Decodable>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) {
        let endpoint: EndpointType = getEndpoint(from: service)

        #warning("Create custom Queues DON'T USER QOS, it's dog shit")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.router.request(endpoint: endpoint) { data, response, error in
                let httpResponse = strongSelf.handleHTTPResponse(response: response)

                if case .success = httpResponse, let data = data {
                    print("senku [DEBUG] \(String(describing: type(of: self))) - success data!!! @ \(response?.url?.absoluteString ?? "")")
                    guard let json = strongSelf.decodeData(model, from: data) else {
                        completion(.failure(JSONDecodingError.errorDecoding))
                        return
                    }
                    completion(.success(json))
                }

                if let error = error { completion(.failure(error)) }

                if case .failure(let msg) = httpResponse {
                    print("senku [❌] \(String(describing: type(of: self))) - ACError: \(msg)")
                }
            }
        }
    }

    func makeResourceRequest(in screen: ScreenType, from path: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        /// Check if the path is empty
        guard !path.isEmpty else { completion(.failure(NetworkError.errorPathEmpty)); return }

        let cache = CacheManager.shared.getCache(from: screen)

        // Check for the resource in the cache first
        if let cacheValue = cache?.load(from: path), let unwrapped = cacheValue.value as? Data {
            completion(.success(unwrapped))
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { completion(.failure(NetworkError.errorMissingURL)); return }
            guard let url = URL(string: path) else { completion(.failure(NetworkError.errorMissingURL)); return }

            strongSelf.router.request(from: url) { data, response, error in
                let httpResponse = strongSelf.handleHTTPResponse(response: response)
                if case .success = httpResponse, let data = data {
                    cache?.save(key: path, value: data)
                    completion(.success(data))
                }
                if let error = error { completion(.failure(error)) }
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
            case .season(let endpoint):
                return endpoint
            case .promo(let endpoint):
                return endpoint
            case .top(let endpoint):
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
