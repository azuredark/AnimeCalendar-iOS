//
//  UIView+Dimensions.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/01/23.
//

import UIKit

extension UIView {
    typealias Dimension = (value: CGFloat, isActive: Bool)
    typealias Dimensions = (width: Dimension, height: Dimension)

    /// Set the **width and height** of the current view by **custom** settings of **on/off**.
    @available(*, deprecated, message: "Too much boiler for simple problem")
    func setSize(by dimensions: Dimensions) {
        self.translatesAutoresizingMaskIntoConstraints = false

        let width: Dimension = dimensions.width
        let height: Dimension = dimensions.height

        self.widthAnchor.constraint(equalToConstant: width.value).isActive = width.isActive
        self.heightAnchor.constraint(equalToConstant: height.value).isActive = height.isActive
    }
}
