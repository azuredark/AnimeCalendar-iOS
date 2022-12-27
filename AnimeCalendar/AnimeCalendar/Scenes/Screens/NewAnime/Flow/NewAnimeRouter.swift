//
//  NewAnimeRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import UIKit

protocol NewAnimeRoutable {
    func start(presenter: NewAnimePresentable) -> Screen
}

final class NewAnimeRouter {
    // MARK: State
    weak private var baseNavigation: UINavigationController?

    // MARK: Initializers
    init(baseNavigation: UINavigationController?) {
        self.baseNavigation = baseNavigation
    }
    
    // MARK: Methods
}

extension NewAnimeRouter: NewAnimeRoutable {
    func start(presenter: NewAnimePresentable) -> Screen {
        return NewAnimeScreen(presenter: presenter)
    }
}
