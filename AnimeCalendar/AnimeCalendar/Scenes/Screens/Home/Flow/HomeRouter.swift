//
//  HomeRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/10/22.
//

import UIKit

/**
 HomeRoutable, interactor's exposed methods
 */
protocol HomeRoutable {
    func start(presenter: HomePresentable) -> Screen
}

final class HomeRouter {
    // MARK: State
    weak private var baseNavigation: UINavigationController?
    
    // MARK: Initializers
    init(baseNavigation: UINavigationController) {
        self.baseNavigation = baseNavigation
    }
}

extension HomeRouter: HomeRoutable {
    /// Creates the HomeScreen.
    /// - Parameter presenter: Home's presenter.
    /// - Returns: Screen
    func start(presenter: HomePresentable) -> Screen {
        return HomeScreen(presenter: presenter)
    }
}
