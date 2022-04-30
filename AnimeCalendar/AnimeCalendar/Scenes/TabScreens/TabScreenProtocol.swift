//
//  TabContract.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

protocol TabScreenProtocol: AnyObject {
  func configureScreen()
  func configureNavigationItems()
  func configureLeftNavigationItems()
  func configureRightNavigationItems()
}
