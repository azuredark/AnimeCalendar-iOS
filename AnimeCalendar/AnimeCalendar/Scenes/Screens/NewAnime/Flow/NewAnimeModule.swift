//
//  NewAnimeModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

final class NewAnimeModule {
    // MARK: State
    private let presenter: NewAnimePresentable

    // MARK: Initializers
    init(requestsManager: RequestProtocol) {
        let interactor = NewAnimeInteractor(requestsManager: requestsManager)
        let router = NewAnimeRouter()
        self.presenter = NewAnimePresenter(interactor: interactor, router: router)
    }
}

extension NewAnimeModule {
    func start() -> Screen {
        return presenter.start()
    }
}
