//
//  BootManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class BootManager {
  private let requestsManager: RequestProtocol = RequestsManager()

  func getRootController(_ rootViewControllerType: RootControllerType) -> RootViewController {
    let rootControllerFactory = RootControllerFactory(requestsManager)
    let rootController = rootControllerFactory.getRootController(rootViewControllerType)
    return rootController
  }
}
