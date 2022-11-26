//
//  RequestsManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

protocol RequestProtocol {
    var network: Requestable { get }
    var local: Requestable { get }
    var mock: Requestable { get }
    
    func getRequestResponsible(_ responsible: RequestResponsibleType) -> Requestable
}

// TODO: Should the requests be singletons??
final class RequestsManager: RequestProtocol {
    private(set) lazy var network: Requestable = NetworkManager()
    private(set) lazy var local: Requestable = LocalManager()
    private(set) lazy var mock: Requestable = MocksManager()
    
    func getRequestResponsible(_ responsible: RequestResponsibleType) -> Requestable {
        if case .mock = responsible { return mock }
        if case .local = responsible { return local }
        return network
    }
}

enum Service {
    case anime(AnimeEndpoint)
    case user(UserEndpoint)
    case manga(MangaEndpoint)
    case season(SeasonEndpoint)
    case promo(PromoEndpoint)
}

enum RequestResponsibleType {
    case network
    case local
    case mock
}
