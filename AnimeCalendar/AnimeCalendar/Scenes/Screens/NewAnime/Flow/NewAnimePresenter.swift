//
//  NewAnimePresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol NewAnimePresentable: NSObject {
    func start() -> Screen
}

final class NewAnimePresenter: NSObject {
    // MARK: State
    private let interactor: NewAnimeInteractive
    private let router: NewAnimeRoutable

    // MARK: Initializers
    init(interactor: NewAnimeInteractive, router: NewAnimeRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension NewAnimePresenter: NewAnimePresentable {
    func start() -> Screen {
        router.start(presenter: self)
    }
}
