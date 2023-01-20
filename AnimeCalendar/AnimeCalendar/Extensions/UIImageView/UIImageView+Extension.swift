//
//  UIImageViewExtension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/05/22.
//

import Foundation
import UIKit.UIImageView

extension UIImageView {
  func imageFromServerURL(urlString: String, placeholderImage: UIImage) {
//    guard let url = URL(string: urlString) else { self.image = placeholderImage; return }
  }

  func imageFromBundle(imageName: String) {
    self.image = UIImage(named: imageName)
  }
}
