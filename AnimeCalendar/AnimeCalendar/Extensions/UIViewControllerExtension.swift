//
//  UIViewControllerExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit.UIViewController

extension UIViewController {
  // Add child VCs
  func addChildVC(_ child: UIViewController) {
    self.addChild(child)
    self.view.addSubview(child.view)
    child.didMove(toParent: self)
  }
}
