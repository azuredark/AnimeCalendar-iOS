//
//  TabBarItemContract.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIImage

// Contract - TabBarItem
protocol TabBarItem {
  var requestsManager: RequestProtocol { get }
  var screen: ScreenProtocol { get }
  var tabBadge: String? { get }
  var tabImage: UIImage { get }
  var tabTitle: String? { get }
}

extension TabBarItem {
  func wrapNavigation() -> CustomNavigationController {
//    return UINavigationController(rootViewController: screen)
    return CustomNavigationController(screen)
  }
}

// TODO: REFACTOR INTO SEPARATE MODULE
final class CustomNavigationController: UINavigationController, CustomNavigation {
  var rootViewController: ScreenProtocol

  /// # Only for NON-DARKMODE approach, should eventually be removed or kept until there is a custom dark mode configured
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(_ rootViewController: ScreenProtocol) {
    self.rootViewController = rootViewController
    super.init(rootViewController: rootViewController)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

protocol CustomNavigation: UINavigationController {
  var rootViewController: ScreenProtocol { get set }
}
