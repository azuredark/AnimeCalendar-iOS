//
//  NewAnimeRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol NewAnimeRoutable {
    func start(presenter: NewAnimePresentable) -> Screen
}

final class NewAnimeRouter {
    // MARK: State

    // MARK: Initializers
    init() {}

    // MARK: Methods
}

extension NewAnimeRouter: NewAnimeRoutable {
    func start(presenter: NewAnimePresentable) -> Screen {
        return NewAnimeScreen(presenter: presenter)
    }
}
