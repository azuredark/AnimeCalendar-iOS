//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

/// # Override tabbar and configure hittest
final class CustomTabBarController: UITabBarController {
  // TODO: TabBarButton IS CREATED TWICE, ONCE HERE AND THEN @HomeScreen
  private lazy var newScheduledAnimeButton: TabBarButton = NewScheduledAnimeButton()
  init() {
    super.init(nibName: nil, bundle: nil)
    configureTabBar()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CustomTabBarController: TabBarWithMiddleButton {
  func configureTabBar() {
    tabBar.backgroundColor = Color.white
    tabBar.unselectedItemTintColor = Color.lightGray
    tabBar.tintColor = Color.cobalt
    tabBar.itemPositioning = .fill
  }

  func configureMiddleButton(in tabBarView: UITabBar) {
    newScheduledAnimeButton.createButton(in: tabBarView)
  }

  func configureButtonPresentingView(presents screen: ScreenProtocol) {
    newScheduledAnimeButton.configureButtonPresentingView(presents: screen)
  }
}
