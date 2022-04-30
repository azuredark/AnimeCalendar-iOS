//
//  RootScreenProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import UIKit.UIViewController

final class RootScreenWrapper {
  // Making it weak wouldn't make much sense, as it doesn't reference back
  private let rootVC: ScreenProtocol

  init(rootVC: ScreenProtocol) {
    self.rootVC = rootVC
  }

  func wrapRootVC() -> UIViewController {
    return UINavigationController(rootViewController: rootVC)
  }
}
