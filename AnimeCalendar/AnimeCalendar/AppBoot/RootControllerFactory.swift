//
//  RootControllerFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

final class RootControllerFactory {
  private let requestsManager: RequestProtocol

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }

  func getRootController(_ rootViewControllerType: RootControllerType) -> RootViewController {
    switch rootViewControllerType {
      // For TabBar with all screens
      case .rootTabBar:
        return TabBarManager(requestsManager)

      // For individual screens
      case .rootScreen(let screen):
        let screenFactory = ScreenFactory(requestsManager)
        let selectedScreen: Screen = screenFactory.getRootScreen(screen)
        return selectedScreen
    }
  }
}
