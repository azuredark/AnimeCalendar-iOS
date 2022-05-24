//
//  ScreenFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

final class ScreenFactory {
  let requestsManager: RequestProtocol
  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }

  func getRootScreen(_ screen: ScreenType) -> ScreenProtocol {
    switch screen {
      case .homeScreen:
        return HomeScreen(requestsManager: requestsManager)
      case .newAnimeScreen:
        return NewAnimeScreen(requestsManager: requestsManager)
      case .animeCalendarScreen:
        return AnimeCalendarScreen(requestsManager: requestsManager)
    }
  }
}
