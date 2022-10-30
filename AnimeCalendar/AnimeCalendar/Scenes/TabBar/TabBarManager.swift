//
//  TabBarManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

final class TabBarManager {
  private let requestsManager: RequestProtocol
  private lazy var tabBarController: TabBarWithMiddleButton = CustomTabBarController()
  private lazy var screenFactory = ScreenFactory(requestsManager)

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    configureTabManager()
  }

  private func configureTabController() {
    // Presented by the tapping the TabBarItem
    let homeVC = screenFactory.getRootScreen(.homeScreen).getRootViewController()
    let animeCalendarVC = screenFactory.getRootScreen(.calendarScreen).getRootViewController()

    // TabBar items (ViewControllers)
    let tabBarViewControllers = [homeVC, animeCalendarVC]
    tabBarController.setViewControllers(tabBarViewControllers, animated: false)
  }

  private func configureTabBarMiddleButton() {
    // Configuring the Middle Button, alonside it's press-action
    tabBarController.configureMiddleButton(in: tabBarController.tabBar)
    tabBarController.configureMiddleButtonAction(using: requestsManager)
  }

   private func configureTabManager() {
    configureTabController()
    configureTabBarMiddleButton()
  }
}

extension TabBarManager: RootViewController {
  func getRootViewController() -> UIViewController {
    return tabBarController
  }
}
