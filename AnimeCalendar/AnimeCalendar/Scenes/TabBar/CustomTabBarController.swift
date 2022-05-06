//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomTabBarController: UITabBarController {
  /// # Overriding properties

  init() {
    super.init(nibName: nil, bundle: nil)
    configureTabBar()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CustomTabBarController: TabBarProtocol {
  func configureTabBar() {
//    self.tabBar.barTintColor = .red
    self.tabBar.backgroundColor = Color.white
    self.tabBar.unselectedItemTintColor = Color.lightGray
    self.tabBar.tintColor = Color.cobalt
  }
}
