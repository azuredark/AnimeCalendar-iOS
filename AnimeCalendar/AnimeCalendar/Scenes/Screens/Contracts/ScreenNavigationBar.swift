//
//  NavigationBarProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import Foundation

protocol ScreenNavigationBar {
  var screen: ScreenProtocol? { get set }
  func configureLeftNavigationItems()
  func configureRightNavigationItems()
}
