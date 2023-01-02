//
//  ACStack+Models.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/01/23.
//

import UIKit

extension ACStack {
    /// Wrapper for CGFloat with optional **width** and/or **height**.
    struct Size {
        var width: CGFloat?
        var height: CGFloat?

        /// # Initializers
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
        }

        init(width: CGFloat) {
            self.width = width
            self.height = nil
        }

        init(height: CGFloat) {
            self.height = height
            self.width = nil
        }

        /// Transform the custom **Size** into **CGSize**
        var cgSize: CGSize {
            var size: (width: CGFloat, height: CGFloat) = (0, 0)
            if let width = width {
                size.width = width
            } else { size.width = .zero }

            if let height = height {
                size.height = height
            } else { size.height = .zero }

            return CGSize(width: size.width, height: size.height)
        }
    }

    struct Text {
        var lines: Int = 0
        var alignment: NSTextAlignment = .left
        var textColor: UIColor = Color.cream
        var font: UIFont = .systemFont(ofSize: 12, weight: .medium)

        /// # Initializers
        init(lines: Int, alignment: NSTextAlignment, textColor: UIColor, font: UIFont) {
            self.lines = lines
            self.alignment = alignment
            self.textColor = textColor
            self.font = font
        }

        init() {}
    }

    struct Image {
        var image = UIImage()
        var tint: UIColor?
        var size = ACStack.Size(width: 0, height: 0)

        init(image: UIImage, tint: UIColor?, size: ACStack.Size) {
            self.image = image
            self.tint = tint
            self.size = size
        }

        init() {}

        /// Create a new object with the same instance properties but a new **image**.
        mutating func with(image: UIImage) -> Self {
            self.image = image
            return self
        }
    }
}
