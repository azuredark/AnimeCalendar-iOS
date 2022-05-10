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

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    configureTabManager()
  }

  fileprivate func configureTabController() {
    let screenFactory = ScreenFactory(requestsManager)

    let homeVC = screenFactory.getRootScreen(.homeScreen).getRootViewController()
    let newAnimeVC = screenFactory.getRootScreen(.newAnimeScreen).getRootViewController()
    let animeCalendarVC = screenFactory.getRootScreen(.animeCalendarScreen).getRootViewController()

    let tabBarViewControllers = [homeVC, newAnimeVC, animeCalendarVC]
    tabBarController.setViewControllers(tabBarViewControllers, animated: false)
  }

  fileprivate func configureTabBarMiddleButton() {
    // Disabling NewScheduledAnime's TabBarItem interaction, so it only works when the button is pressed
    tabBarController.tabBar.items?[1].isEnabled = false
    // Configuring middle tabbar button (Inside TabBar's view but with it's TabBarItem interaction disabled)
    tabBarController.configureMiddleButton(in: tabBarController.tabBar)
  }

  fileprivate func configureTabManager() {
    configureTabController()
    configureTabBarMiddleButton()
  }
}

extension TabBarManager: RootViewController {
  func getRootViewController() -> UIViewController {
    return tabBarController
  }
}
