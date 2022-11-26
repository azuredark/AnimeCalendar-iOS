//
//  MocksManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class MocksManager: Requestable {
    func makeRequest<T>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) where T: Decodable {
        let endpoint: EndpointType = getEndpoint(from: service)
        let fileName: String = EndpointFile(endpoint: endpoint).rawValue
        print("senku [🧪] MockRouter - service: \(endpoint.basePath) | fileName: \(fileName).json")

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(MockError.mockFileNotFoundError)); return
        }

        do {
            let data = try Data(contentsOf: url)
            let json: T = try JSONDecoder().decode(model, from: data)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion(.success(json))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func makeResourceRequest(in screen: ScreenType, from path: String, _ completion: @escaping (Result<Data, Error>) -> Void) {}
}

private extension MocksManager {
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
        }
    }
}

private enum EndpointFile: String {
    case getAnime             = "anime-q?drstone"
    case getCurrentSeason     = "seasons-now-page?1"
    case getRecentPromosAnime = "watch-promos-page?1"

    /// Create and endpoint file name enum from an endpont type
    init(endpoint: EndpointType) {
        if let endpoint = endpoint as? AnimeEndpoint, endpoint == .getAnime(name: "") {
            self = .getAnime; return
        }

        if let endpoint = endpoint as? SeasonEndpoint, endpoint == .getCurrentSeasonAnime(page: 1) {
            self = .getCurrentSeason; return
        }
        
        if let endpoint = endpoint as? PromoEndpoint, endpoint == .getRecentPromos(page: 1) {
            self = .getRecentPromosAnime; return
        }

        self = .getAnime
    }
}

private enum MockError: String, Error {
    case mockFileNotFoundError = "MockError - File not found"
}
