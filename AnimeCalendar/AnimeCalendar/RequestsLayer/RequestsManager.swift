//
//  RequestsManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

enum AnimeRequest {
    case getAnime(id: Int)
    case getAnimes
}

enum UserRequest {
    case getUser(id: Int)
}

enum MangaRequest {
    case getManga(id: Int)
    case getMangas
}

// TODO: Should the requests be singletons??
final class RequestsManager: RequestProtocol {
    lazy var network: Requestable = NetworkManager()
    lazy var mock: Requestable = MocksManager()
    // user local requests manager
}

enum Service {
    case anime(AnimeEndpoint)
    case user(UserEndpoint)
    case manga(MangaEndpoint)
}
