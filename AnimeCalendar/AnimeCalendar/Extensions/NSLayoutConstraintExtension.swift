//
//  NSLayoutConstraintExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 4/05/22.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
  func updateMultiplier(to multiplier: CGFloat) {
    NSLayoutConstraint.deactivate([self])
    let newConstraint = NSLayoutConstraint(item: firstItem as Any, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: 0)
    newConstraint.priority = self.priority
    newConstraint.identifier = self.identifier
    NSLayoutConstraint.activate([newConstraint])
  }
}
