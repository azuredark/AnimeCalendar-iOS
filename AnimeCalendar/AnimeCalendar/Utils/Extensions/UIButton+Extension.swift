//
//  UIButton+Extension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/11/22.
//

import UIKit

extension UIButton {
    func addButtonShadow(shadow: Shadow) {
        self.layer.shadowColor = shadow.color.cgColor
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowRadius = shadow.blur
        self.layer.shadowOpacity = shadow.opacity
        self.layer.cornerRadius = shadow.cornerRadius
        self.clipsToBounds = false
    }
}
