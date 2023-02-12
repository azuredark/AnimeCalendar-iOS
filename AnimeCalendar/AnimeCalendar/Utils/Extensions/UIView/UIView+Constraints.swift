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

    func fitViewTo(_ view: UIView, padding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
}
