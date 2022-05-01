//
//  UIViewExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

public extension UIView {
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
}
