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
  private let tabBarController: TabBarProtocol = CustomTabBarController()

  private var tabBarItems = [TabBarItem]()

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    configureTabManager()
  }

  fileprivate func configureTabScreens() {
    let tabFactory = TabBarFactory(requestsManager)

    let homeTabItem: TabBarItem = tabFactory.getTabBarScreen(.homeTab)
    let newScheduledAnimeTabItem: TabBarItem = tabFactory.getTabBarScreen(.newAnimeTab)
    let animeCalendarTabItem: TabBarItem = tabFactory.getTabBarScreen(.animeCalendarTab)
    tabBarItems = [homeTabItem, newScheduledAnimeTabItem, animeCalendarTabItem]
  }

  fileprivate func configureTabController() {
    tabBarController.viewControllers = tabBarItems.map { $0.wrapNavigation() }
  }

  fileprivate func configureTabItems() {
    guard let items = tabBarController.tabBar.items else { return }
    for (tabBarItem, item) in zip(tabBarItems, items) {
      item.badgeValue = tabBarItem.tabBadge
      item.title = tabBarItem.tabTitle
      item.image = tabBarItem.tabImage
    }
  }

  fileprivate func configureTabManager() {
    configureTabScreens()
    configureTabController()
    configureTabItems()
  }

  public func getConfiguredTabBar() -> UITabBarController {
    return tabBarController
  }
}
