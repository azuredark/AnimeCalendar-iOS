//
//  RequestsManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

// TODO: Should the requests be singletons??
final class RequestsManager: RequestProtocol {
    private(set) lazy var network: Requestable = NetworkManager()
    private(set) lazy var local: Requestable = LocalManager()
    private(set) lazy var mock: Requestable = MocksManager()
}

enum Service {
    case anime(AnimeEndpoint)
    case user(UserEndpoint)
    case manga(MangaEndpoint)
}
