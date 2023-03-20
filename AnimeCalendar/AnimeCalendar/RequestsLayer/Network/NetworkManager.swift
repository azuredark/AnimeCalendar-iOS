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

    /// # Queues
    private lazy var queue = DispatchQueue(label: "ac_network", qos: .userInitiated)
    private lazy var resourceQueue = DispatchQueue(label: "ac_network_resource", qos: .userInitiated)

    /// # Sleep before retry
    private let SLEEP_BEFORE_RETRY_SECONDS: CGFloat = 1.0

    // MARK: Methods
    func makeRequest<T: Decodable>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) {
        let endpoint: EndpointType = getEndpoint(from: service)

        queue.async { [weak self] in
            guard let self else { return }
            self.launchNetworkRequest(retries: endpoint.retries, model, endpoint: endpoint, completion: completion)
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

        resourceQueue.async { [weak self] in
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
}

private extension NetworkManager {
    func launchNetworkRequest<T: Decodable>(retries: Int, _ model: T.Type, endpoint: EndpointType, completion: @escaping (Result<T?, Error>) -> Void) {
        router.request(endpoint: endpoint) { [weak self] (data, response, error) in
            guard let self else { return }
            let httpResponse = self.handleHTTPResponse(response: response)

            if case .success(let code) = httpResponse, let data = data {
                Logger.log(.network, .success, msg: "Network HTTP response - Success data! @ \(response?.url?.absoluteString ?? "") | Code: \(code)")
                guard let json = self.decodeData(model, from: data) else {
                    completion(.failure(JSONDecodingError.errorDecoding))
                    return
                }
                completion(.success(json))
            }

            if let error = error {
                Logger.log(.network, .error, msg: "Network Error: \(error) | @ \(endpoint.basePath)")
                self.attemptToRetry(retries, model, endpoint, completion: completion)
                return
            }

            if case .failure(let msg, let code) = httpResponse {
                Logger.log(.network, .error, msg: "Network HTTP response - Error: \(msg) @ \(endpoint.basePath) | Code: \(code)")
                self.attemptToRetry(retries, model, endpoint, completion: completion)
            }
        }
    }

    func attemptToRetry<T: Decodable>(_ retriesLeft: Int, _ model: T.Type, _ endpoint: EndpointType, completion: @escaping (Result<T?, Error>) -> Void) {
        if retriesLeft > 1 {
            Logger.log(.info, msg: "Retries left: \(retriesLeft-1)")
            DispatchQueue.main.asyncAfter(deadline: .now() + SLEEP_BEFORE_RETRY_SECONDS) { [weak self] in
                guard let self else { return }
                self.launchNetworkRequest(retries: retriesLeft-1, model, endpoint: endpoint, completion: completion)
            }
        } else {
            completion(.failure(NetworkError.errorHttpCode))
        }
    }

    func getEndpoint(from service: Service) -> EndpointType {
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
            case 200 ... 299: return .success(code: code)
            case 400: return .failure(NetworkResponse.JIKAN_ERROR_BAD_REQUEST.rawValue, code: code)
            case 404: return .failure(NetworkResponse.notFound.rawValue, code: code)
            case 405: return .failure(NetworkResponse.JIKAN_ERROR_METHOD_NOT_ALLOWED.rawValue, code: code)
            case 429: return .failure(NetworkResponse.JIKAN_ERROR_TOO_MANY_REQUEST.rawValue, code: code)
            case 430 ..< 500: return .failure(NetworkResponse.authenticationError.rawValue, code: code)
            case 500: return .failure(NetworkResponse.internalServerError.rawValue, code: code)
            case 501 ... 599: return .failure(NetworkResponse.badRequest.rawValue, code: code)
            case 600: return .failure(NetworkResponse.outdated.rawValue, code: code)
            default: return .failure(NetworkResponse.failed.rawValue, code: code)
        }
    }

    func decodeData<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(type, from: data)
            return json
        } catch {
            Logger.log(.network, .error, msg: "Network decoding error: \(error)")
            return nil
        }
    }
}

enum JSONDecodingError: String, Error {
    case errorDecoding
    case errorEncoding
}
