//
//  AnimeCalendarTabItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIImage

final class AnimeCalendarTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol

  public private(set) lazy var screen: ScreenProtocol = AnimeCalendarScreen(requestsManager: requestsManager)
  public private(set) var tabBadge: String?
  public private(set) var tabImage = UIImage(systemName: "calendar")!
  public private(set) var tabTitle: String?

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}
