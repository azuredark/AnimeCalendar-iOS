//
//  ProductionBoot.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation
import UIKit.UIViewController

final class ProductionBoot: Boot {
  internal lazy var requestsManager: RequestProtocol = RequestsManager()
  internal lazy var rootVC: ScreenProtocol = HomeScreen(requestsManager: requestsManager)

  // Should not depend on a concrete type, make a RootControllerFactory or some sort of builder
  func createRootScreen() -> UITabBarController {
    let tabBarManager = TabBarManager(requestsManager)
    return tabBarManager.getConfiguredTabBar()
  }
}
