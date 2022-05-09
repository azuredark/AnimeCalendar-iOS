//
//  TabBarProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

protocol TabBarProtocol: UITabBarController {
  func configureTabBar()
}

protocol TabBarWithMiddleButton: TabBarProtocol {
  func configureMiddleButton(in tabBarView: UITabBar)
  func configureButtonPresentingView(presents screen: ScreenProtocol)
}
