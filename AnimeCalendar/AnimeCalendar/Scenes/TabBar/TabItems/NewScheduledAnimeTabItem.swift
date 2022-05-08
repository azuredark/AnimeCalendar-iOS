//
//  NewScheduledAnimeTabItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIImage

/// # It's empty just to preserve the space between the Home and Calendar Items. The NewScheduledAnimeItem will be in fact a button insithe the UITabBarController view's and not part of the TabItems perse.
final class NewScheduledAnimeTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol
  public private(set) lazy var screen: ScreenProtocol = NewScheduledAnimeScreen(requestsManager: requestsManager)
  public private(set) var tabBadge: String?
  public private(set) var tabImage: UIImage?
  public private(set) var tabTitle: String?
  public private(set) var enabled: Bool = false

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}
