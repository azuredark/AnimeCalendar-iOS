//
//  TabBarManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

final class TabBarManager {
    // MARK: State
    private lazy var tabBarController: TabBarWithMiddleButton = CustomTabBarController()
    /// Presented by the tapping the TabBarItem
    private let tabs: [ScreenType]
    private let middleButton: Bool
    
    // MARK: Initializers
    init(tabs: [ScreenType], middleButton: Bool) {
        self.tabs = tabs
        self.middleButton = middleButton
        configureTabManager()
    }
}

// MARK: Root View Controller
extension TabBarManager: RootViewController {
    func getRootViewController() -> UIViewController {
        return tabBarController
    }
}

private extension TabBarManager {
    func configureTabController(with factory: ScreenFactory) {
        // TabBar items (ViewControllers)
        let tabBarViewControllers = getControllers(with: factory)
        tabBarController.setViewControllers(tabBarViewControllers, animated: false)
    }
    
    func configureTabManager() {
        let screenFactory = ScreenFactory()
        configureTabController(with: screenFactory)
        
        if middleButton { configureTabBarMiddleButton(with: screenFactory) }
    }
    
    func configureTabBarMiddleButton(with factory: ScreenFactory) {
        /// NewAnime module
        let discoverVC = factory.getModuleBaseController(.discoverScreen)
        // Configuring the Middle Button, alonside its press-action
        tabBarController.configureMiddleButton()
        tabBarController.configureMiddleButtonAction(presenting: discoverVC)
    }


    func getControllers(with factory: ScreenFactory) -> [UIViewController] {
        return tabs.reduce([UIViewController]()) { partialResult, screen in
            partialResult + [factory.getModuleBaseController(screen)]
        }
    }
}
