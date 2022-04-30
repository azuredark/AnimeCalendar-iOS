//
//  TabBarFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation

final class TabBarFactory {
  private let requestsManager: RequestProtocol

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }

  func getTabBarScreen(_ tabBar: TabBarItemTypes) -> TabBarItem {
    switch tabBar {
      case .homeTab:
        return HomeScreenTabItem(requestsManager)
      case .newAnimeTab:
        return NewScheduledAnimeTabItem(requestsManager)
      case .animeCalendarTab:
        return AnimeCalendarTabItem(requestsManager)
    }
  }
}
