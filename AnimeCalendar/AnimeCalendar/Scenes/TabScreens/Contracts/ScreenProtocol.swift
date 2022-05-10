//
//  ScreenProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation
import UIKit.UIViewController

protocol ScreenProtocol: UIViewController, RootViewController {
  var requestsManager: RequestProtocol { get set }

  func configureNavigationItems()
  func configureRightNavigationItems()
  func configureLeftNavigationItems()
}

protocol ScreenWithTabItem: ScreenProtocol {
  func configureTabItem()
}
