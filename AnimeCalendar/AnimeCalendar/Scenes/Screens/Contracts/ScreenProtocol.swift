//
//  ScreenProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation
import UIKit.UIViewController

/// # All Screens must conform to `RootViweController`
protocol ScreenProtocol: UIViewController, RootViewController {
  var requestsManager: RequestProtocol { get set }

  func configureNavigationItems()
  func configureRightNavigationItems()
  func configureLeftNavigationItems()
}

protocol ScreenWithTabItem: ScreenProtocol {
  func configureTabItem()
}
