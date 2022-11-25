//
//  UIViewExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import UIKit

extension UIView {
    /// Adds a **Shadow** to the current view.
    /// - Parameter shadow: A **Shadow** type struct containing shadow properties.
    ///
    /// - Warning: Should only be used for **UIView** not **UIButton** or **UIImageView**
    ///
    /// The technique used takes advantage of the *shadowPath* to define the shadow's bounds instead of making UIKit calcuate them on the run.
    func addShadow(with shadow: Shadow) {
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowOpacity = shadow.opacity
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadow.cornerRadius).cgPath
        self.layer.cornerRadius = shadow.cornerRadius
        self.layer.shadowRadius = shadow.blur // blur
        self.layer.shadowColor = shadow.color.cgColor
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    /// Adds corner radius to the current view.
    ///
    /// - Warning: Don't use along with *addShadow* as this method clips the bounds and may remove the shadow. Instead, set *cornerRadius* accordingly inside the ShadowBuilder
    /// - Parameter radius: The corner's radius.
    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addShadowForImageView(shadow: Shadow, fillColor: UIColor) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadow.cornerRadius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowRadius = shadow.blur
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = 0.8
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
