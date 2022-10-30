//
//  NewAnimeInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol NewAnimeInteractive {}

final class NewAnimeInteractor {
    // MARK: State
    private let requestsManager: RequestProtocol

    // MARK: Initializers
    init(requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }

    // MARK: Methods
}

extension NewAnimeInteractor: NewAnimeInteractive {}
