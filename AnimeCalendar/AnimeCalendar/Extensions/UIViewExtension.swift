//
//  UIViewExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

// TODO: Create common private methods? To avoid so much DRY
public extension UIView {
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

  /// # For Views without requiring an Image with shadow
  func addShadowLayer(shadow: Shadow, layerRadius: CGFloat) {
    self.layer.cornerRadius = layerRadius
    self.layer.shadowColor = shadow.color.cgColor
    self.layer.shadowOffset = shadow.offset
    self.layer.shadowRadius = shadow.radius
    self.layer.shadowOpacity = shadow.opacity
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: layerRadius).cgPath
  }

  func addBottomShadow(shadow: Shadow, layerRadius: CGFloat) {
    self.layer.cornerRadius = layerRadius
    self.layer.shadowColor = shadow.color.cgColor
    self.layer.shadowOffset = shadow.offset
    self.layer.shadowRadius = shadow.radius
    self.layer.shadowOpacity = shadow.opacity
    self.layer.shadowPath = UIBezierPath(
      rect: CGRect(x: self.bounds.minX + self.bounds.width * 0.02,
                   y: self.bounds.maxY * 1.05,
                   width: self.bounds.width * 0.9,
                   height: self.bounds.height * 0.04)).cgPath
  }

  func addCornerRadius(radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}
