//
//  Constraints.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import Foundation
import UIKit

enum Constraints {
    /// Updates a Constraint's multiplier value.
    /// - Parameter constraint: Constraint to update.
    /// - Parameter multiplier: New multiplier value for the Constraint.
    static func updateConstraintMultiplier(_ constraint: inout NSLayoutConstraint, to multiplier: CGFloat) {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem as Any,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier, constant: 0)
        newConstraint.priority = constraint.priority
        newConstraint.identifier = constraint.identifier
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }
}
