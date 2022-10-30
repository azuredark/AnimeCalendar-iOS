//
//  HomeRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/10/22.
//

import Foundation

/**
 HomeRoutable, interactor's exposed methods
 */
protocol HomeRoutable {
    func start(presenter: HomePresentable) -> Screen
}

final class HomeRouter {
    // MARK: State
    // MARK: Initializers
    init() {}
}

extension HomeRouter: HomeRoutable {
    /// Creates the HomeScreen.
    /// - Parameter presenter: Home's presenter.
    /// - Returns: Screen
    func start(presenter: HomePresentable) -> Screen {
        return HomeScreen(presenter: presenter)
    }
}
