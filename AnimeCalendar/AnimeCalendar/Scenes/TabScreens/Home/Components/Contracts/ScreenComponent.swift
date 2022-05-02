//
//  ScreenComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import Foundation
import UIKit.UIViewController

protocol ScreenComponent: UIViewController {
  func configureView()
  func configureSubviews()
}
