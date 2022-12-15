//
//  Path.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

struct Shadow {
    var blur: CGFloat
    var offset: CGSize
    var opacity: Float
    var color: UIColor
    var cornerRadius: CGFloat

    /// Convenience init, default shadow
    ///
    /// Strongly recommended using the **ShadowBuilder** instead
    init() {
        self.init(blur: 4.0,
                  offset: CGSize(width: 0, height: 0),
                  opacity: 1.0,
                  color: Color.black.withAlphaComponent(0.25),
                  cornerRadius: 0)
    }

    /// Designed initialzier, fully custom shadow.
    ///
    /// If created alone, it's strongly recommended using the **ShadowBuilder** instead
    init(blur: CGFloat, offset: CGSize, opacity: Float, color: UIColor, cornerRadius: CGFloat) {
        self.blur = blur
        self.offset = offset
        self.opacity = opacity
        self.color = color
        self.cornerRadius = cornerRadius
    }
}

/// Pre-defined set of shadows
enum ShadowType {
    case bottom
    case full
}

protocol ShadowBuildable {
    func getTemplate(type shadowType: ShadowType) -> ShadowBuilder
    func with(blur: CGFloat) -> ShadowBuilder
    func with(offset: CGSize) -> ShadowBuilder
    func with(opacity: Float) -> ShadowBuilder
    func with(color: UIColor) -> ShadowBuilder
    func build() -> Shadow
}

final class ShadowBuilder: ShadowBuildable {
    private var blur: CGFloat = 4.0
    private var offset = CGSize(width: 0, height: 0)
    private var opacity: Float = 1.0
    private var color: UIColor = Color.black.withAlphaComponent(0.25)
    private var cornerRadius: CGFloat = 0

    init() {}

    private init(blur: CGFloat, offset: CGSize, opacity: Float, color: UIColor, cornerRadius: CGFloat) {
        self.blur = blur
        self.offset = offset
        self.opacity = opacity
        self.color = color
        self.cornerRadius = cornerRadius
    }

    /// Create shadow from a pre-defined template.
    /// - Parameter shadowTyp: .
    /// - Returns: ShadowBuilder with pre-defined settings
    func getTemplate(type shadowType: ShadowType) -> ShadowBuilder {
        switch shadowType {
            case .bottom:
                return ShadowBuilder(blur: 4,
                                     offset: CGSize(width: 0, height: 4),
                                     opacity: 0.8,
                                     color: Color.black,
                                     cornerRadius: 0)
            case .full:
                return ShadowBuilder(blur: 4,
                                     offset: .zero,
                                     opacity: 0.8,
                                     color: Color.black,
                                     cornerRadius: 0)
        }
    }

    /// Modifies the current builder's blur.
    /// - Parameter blur: Shadow's blur.
    /// - Returns: New ShadowBuilder
    func with(blur: CGFloat) -> Self {
        self.blur = blur
        return self
    }

    /// Modifies the current builder's offset.
    /// - Parameter offset: Shadow's offset.
    /// - Returns: New ShadowBuilder
    func with(offset: CGSize) -> Self {
        self.offset = offset
        return self
    }

    /// Modifies the current builder's opacity.
    /// - Parameter opacity: Shadow's opacity.
    /// - Returns: New ShadowBuilder
    func with(opacity: Float) -> Self {
        self.opacity = opacity
        return self
    }

    /// Modifies the current builder's color.
    /// - Parameter color: Shadow's color.
    /// - Returns: New ShadowBuilder
    func with(color: UIColor) -> Self {
        self.color = color
        return self
    }

    /// Modifies the current builder's corner radius.
    /// - Parameter cornerRadius: Shadow's corner radius.
    /// - Returns: New ShadowBuilder
    func with(cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    /// Creates a new Shadow.
    /// - Returns: A new shadow with builder settings.
    func build() -> Shadow {
        return Shadow(blur: blur,
                      offset: offset,
                      opacity: opacity,
                      color: color,
                      cornerRadius: cornerRadius)
    }
}
