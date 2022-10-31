//
//  RootControllerFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

final class RootControllerFactory {
    // MARK: Methods
    func getRootController(type rootViewControllerType: RootControllerType) -> RootViewController {
        switch rootViewControllerType {
            /// For TabBar with all screens
            case .rootTabBar:
                return TabBarManager()

            /// For individual screens
            case .rootScreen(let screen):
                let screenFactory = ScreenFactory()
                let selectedScreen: RootViewController = screenFactory.getRootScreen(screen)
                return selectedScreen
        }
    }
}
