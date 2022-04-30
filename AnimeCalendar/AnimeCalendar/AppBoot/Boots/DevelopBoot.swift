//
//  DevelopBoot.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation
import UIKit.UIViewController

final class DevelopBoot: Boot {
  internal lazy var requestsManager: RequestProtocol = RequestsManager()
  internal lazy var rootVC: ScreenProtocol = HomeScreen(requestsManager: requestsManager)

  func createRootScreen() -> UITabBarController {
    let tabBarManager = TabBarManager(requestsManager)
    return tabBarManager.getConfiguredTabBar()
  }

//  func createRootScreen() -> UIViewController {
//    let wrapper = RootScreenWrapper(rootVC: rootVC)
//    let wrappedVC = wrapper.wrapRootVC()
//    return wrappedVC
//  }
}
