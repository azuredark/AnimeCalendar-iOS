//
//  CustomNavigationController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomNavigationController: UINavigationController, CustomNavigation {
  var rootViewController: ScreenProtocol

  /// # Only for NON-DARKMODE approach, should eventually be removed or kept until there is a custom dark mode configured
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  init(_ rootViewController: ScreenProtocol) {
    self.rootViewController = rootViewController
    super.init(rootViewController: self.rootViewController)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

protocol CustomNavigation: UINavigationController {
  var rootViewController: ScreenProtocol { get set }
}
