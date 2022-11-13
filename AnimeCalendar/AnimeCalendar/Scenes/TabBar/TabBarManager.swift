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
    
    // MARK: Initializers
    init() {
        configureTabManager()
    }

    // MARK: Methods
    private func configureTabController(with factory: ScreenFactory) {
        // Presented by the tapping the TabBarItem
        let homeVC = factory.getRootScreen(.homeScreen).getRootViewController()
        let animeCalendarVC = factory.getRootScreen(.calendarScreen).getRootViewController()

        // TabBar items (ViewControllers)
        let tabBarViewControllers = [homeVC, animeCalendarVC]
        tabBarController.setViewControllers(tabBarViewControllers, animated: false)
    }

    private func configureTabBarMiddleButton(with factory: ScreenFactory) {
        /// NewAnime module
        let discoverVC = factory.getRootScreen(.discoverScreen).getRootViewController()
        // Configuring the Middle Button, alonside its press-action
        tabBarController.configureMiddleButton()
        tabBarController.configureMiddleButtonAction(presenting: discoverVC)
    }

    private func configureTabManager() {
        let screenFactory = ScreenFactory()
        configureTabController(with: screenFactory)
        configureTabBarMiddleButton(with: screenFactory)
    }
}

// MARK: Root View Controller
extension TabBarManager: RootViewController {
    func getRootViewController() -> UIViewController {
        return tabBarController
    }
}
