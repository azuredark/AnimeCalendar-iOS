//
//  HomeScreenTabItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIImage

final class HomeScreenTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol
  public private(set) lazy var screen: ScreenProtocol = HomeScreen(requestsManager: requestsManager)
  public private(set) var tabBadge: String? = "1"
  public private(set) var tabImage = UIImage(systemName: "house")!
  public private(set) var tabTitle: String? = nil

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}
