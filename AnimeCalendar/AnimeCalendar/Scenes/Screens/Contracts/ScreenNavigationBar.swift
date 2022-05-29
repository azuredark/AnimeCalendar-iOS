//
//  NavigationBarProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import Foundation

protocol ScreenNavigationBar: AnyObject {
  var screen: Screen? { get set }
  func configureLeftNavigationItems()
  func configureRightNavigationItems()
}
