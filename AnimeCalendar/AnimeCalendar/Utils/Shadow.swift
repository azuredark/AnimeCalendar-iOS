//
//  Path.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

public struct Shadow {
  let radius: CGFloat
  let offset: CGSize
  let opacity: Float
  let color: UIColor

  init(radius: CGFloat, offset: CGSize, opacity: Float, color: UIColor) {
    self.radius = radius
    self.offset = offset
    self.opacity = opacity
    self.color = color
  }

  /// #  Default shadow
  init() {
    self.radius = 10
    self.offset = CGSize(width: 0, height: 0)
    self.opacity = 0.4
    self.color = UIColor.darkGray
  }
}
