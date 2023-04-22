//
//  RootControllerFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import UIKit

final class RootControllerFactory {
    // MARK: Methods
    private lazy var screenFactory = ScreenFactory()
    
    func getRootController(type rootViewControllerType: RootControllerType) -> UIViewController {
        switch rootViewControllerType {
            /// For TabBar with all screens
            case .rootTabBar(let screens, let middleButton):
                let tabBarManager = TabBarManager(tabs: screens, middleButton: middleButton)
                return tabBarManager.getRootViewController()

            /// For individual screens
            case .rootScreen(let screen):
                let selectedScreen = screenFactory.getModuleBaseController(screen)
                return selectedScreen
        }
    }
}
