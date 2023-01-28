//
//  UIView+Constraints.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/01/23.
//

import UIKit

extension UIView {
    func setPriorityForConstraints(_ constraints: [NSLayoutConstraint], with priority: UILayoutPriority) {
        constraints.forEach {
            $0.isActive = false
            $0.priority = priority
            $0.isActive = true
        }
    }
}
