//
//  UIViewExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

// TODO: Create common private methods? To avoid so much DRY
extension UIView {
    /// # For UIImageViews with Shadows and CornerRadius
    /// Requires 2 Views: UIView (Container) & UIImageView (Image)
    func addShadowAndCornerRadius(shadow: Shadow, cornerRadius: CGFloat, fillColor: UIColor) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowRadius = shadow.radius
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = 0.8
        self.layer.insertSublayer(shadowLayer, at: 0)
    }

    /// For Views without requiring an Image with shadow
    /// - Parameter shadow: Shadow object to use inside the layer
    /// - Parameter layerRadius: Radius of the layer
    func addShadowLayer(shadow: Shadow, layerRadius: CGFloat) {
        self.clipsToBounds = false
        self.layer.cornerRadius = layerRadius
        self.layer.shadowColor = shadow.color.cgColor
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowRadius = shadow.radius
        self.layer.shadowOpacity = shadow.opacity
    }

    func addBottomShadow(shadow: Shadow, layerRadius: CGFloat) {
        self.layer.cornerRadius = layerRadius
        self.layer.shadowColor = shadow.color.cgColor
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowRadius = shadow.radius
        self.layer.shadowOpacity = shadow.opacity
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }

    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
