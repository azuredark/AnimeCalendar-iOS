//
//  RootControllerFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import UIKit

final class RootControllerFactory {
    // MARK: Methods
    func getRootController(type rootViewControllerType: RootControllerType) -> UIViewController {
        switch rootViewControllerType {
            /// For TabBar with all screens
            case .rootTabBar:
                return TabBarManager().getRootViewController()

            /// For individual screens
            case .rootScreen(let screen):
                let screenFactory = ScreenFactory()
                let selectedScreen = screenFactory.getModuleBaseController(screen)
                return selectedScreen
        }
    }
}
