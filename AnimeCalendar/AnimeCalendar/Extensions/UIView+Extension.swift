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

    /// Add corner radius to the speificed corners.
    ///
    /// - Warning: Must run when the *subviews* have been layed out, otherwise the mask won't show up.
    /// - Parameter radius: The amount of radius for each corner.
    /// - Parameter corners: The corners to apply the radius to.
    func addCornerRadius(radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // TODO: Currently not working, the content dissappears :(
    typealias CornerRadiuses = (min: CGFloat, max: CGFloat)
    /// Adds 2 different corner radius to the view.
    ///
    /// This method applies the **min** radius to **all the corners**, then applies the **max** radius to the specified ones. This will make the view have 2 different corner radiuses.
    /// - Parameter radiuses: Tuple containing the **min** and **max** corners.
    /// - Parameter corner: The corners where to apply the **max** radius
    @available(*, unavailable,  message: "Doesn't work, don't use :(")
    func addCornerRadius(radiuses: CornerRadiuses, at corners: UIRectCorner) {
        // Apply the smallest to all of the edges
        self.layer.cornerRadius = radiuses.min
        
        /// Path with the max radius applied to the specified corners
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radiuses.max, height: 0))
        
        /// Shape layer
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        layer.mask = mask
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
