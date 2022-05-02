//
//  Path.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

public struct Shadow {
  var radius: CGFloat
  var offset: CGSize
  var opacity: Float
  var color: UIColor

  init(radius: CGFloat, offset: CGSize, opacity: Float, color: UIColor) {
    self.radius = radius
    self.offset = offset
    self.opacity = opacity
    self.color = color
  }

  /// #  Default shadow
  init() {
    self.radius = 5
    self.offset = CGSize(width: -4, height: 0.2)
    self.opacity = 0.3
    self.color = UIColor.darkGray
  }
}
