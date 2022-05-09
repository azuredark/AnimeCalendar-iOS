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
  private var tabBarController: TabBarWithMiddleButton = CustomTabBarController()

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

  fileprivate func configureTabBarMiddleButton() {
    let tabBarScreens = tabBarItems.map { $0.screen }
    let tabBarView = tabBarController.tabBar

    /// # Will only run ONCE, as there is just one NewScheduledAnimeScreen in tabarBarItems
    for case let screen as NewScheduledAnimeScreen in tabBarScreens {
      tabBarController.configureMiddleButton(in: tabBarView)
      tabBarController.configureButtonPresentingView(presents: screen)
    }
  }

  fileprivate func configureTabItems() {
    guard let tabBarControllerItems = tabBarController.tabBar.items else { return }
    for (tabBarControllerItem, tabBarItem) in zip(tabBarControllerItems, tabBarItems) {
      tabBarControllerItem.badgeValue = tabBarItem.tabBadge
      tabBarControllerItem.title = tabBarItem.tabTitle
      tabBarControllerItem.image = tabBarItem.tabImage
      tabBarControllerItem.isEnabled = tabBarItem.enabled
    }
  }

  fileprivate func configureTabManager() {
    configureTabScreens()
    configureTabController()
    configureTabBarMiddleButton()
    configureTabItems()
  }

  public func getConfiguredTabBar() -> UITabBarController {
    return tabBarController
  }
}
