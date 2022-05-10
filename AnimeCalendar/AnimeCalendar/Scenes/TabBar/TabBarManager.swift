//
//  TabBarManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

final class TabBarManager: RootViewController {
  private let requestsManager: RequestProtocol
  private var tabBarController: TabBarWithMiddleButton = CustomTabBarController()

  private var tabBarItems = [TabBarItem]()

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    configureTabManager()
  }

//  fileprivate func configureTabScreens() {
//    let tabFactory = TabBarFactory(requestsManager)
//
//    let homeTabItem: TabBarItem = tabFactory.getTabBarScreen(.homeTab)
//    let newScheduledAnimeTabItem: TabBarItem = tabFactory.getTabBarScreen(.newAnimeTab)
//    let animeCalendarTabItem: TabBarItem = tabFactory.getTabBarScreen(.animeCalendarTab)
//    tabBarItems = [homeTabItem, newScheduledAnimeTabItem, animeCalendarTabItem]
//  }

  fileprivate func configureTabController() {
    let screenFactory = ScreenFactory(requestsManager)

    let homeScreen = screenFactory.getRootScreen(.homeScreen).getRootViewController()
    let newAnimeScreen = screenFactory.getRootScreen(.newAnimeScreen).getRootViewController()
    let animeCalendarScreen = screenFactory.getRootScreen(.animeCalendarScreen).getRootViewController()

    tabBarController.viewControllers = [homeScreen, newAnimeScreen, animeCalendarScreen]
//    tabBarController.viewControllers = [tabBarItems[0].wrapNavigation(), tabBarItems[2].wrapNavigation()]
  }

  fileprivate func configureTabBarMiddleButton() {
    /// # Will only run ONCE, as there is just one NewScheduledAnimeScreen in tabarBarItems
    tabBarController.configureMiddleButton(in: tabBarController.tabBar)
//    for case let screen as NewScheduledAnimeScreen in tabBarScreens {
//      tabBarController.configureButtonPresentingView(presents: screen)
//      tabBarController.present(screen, animated: true)
//      tabBarController.viewControllers![0].present(screen, animated: true)
//    }
//    tabBarController.viewControllers![0].present(tabBarItems[1].screen, animated: true)
//    let customScreen = CustomScreen()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self]  in
//      print("PRESENT VC")
//    }
  }

//  fileprivate func configureTabItems() {
//    guard let tabBarControllerItems = tabBarController.tabBar.items else { return }
//    for (tabBarControllerItem, tabBarItem) in zip(tabBarControllerItems, tabBarItems) {
//      tabBarControllerItem.badgeValue = tabBarItem.tabBadge
//      tabBarControllerItem.title = tabBarItem.tabTitle
//      tabBarControllerItem.image = tabBarItem.tabImage
//      tabBarControllerItem.isEnabled = tabBarItem.enabled
//    }
//  }

  fileprivate func configureTabManager() {
//    configureTabScreens()
    configureTabController()
    configureTabBarMiddleButton()
//    configureTabItems()
  }

  func getRootViewController() -> UIViewController {
    return tabBarController
  }
}
