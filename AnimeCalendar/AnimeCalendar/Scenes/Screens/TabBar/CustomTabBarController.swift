//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

/// # Override tabbar and configure hittest
final class CustomTabBarController: UITabBarController, TabBarProtocol {
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
    tabBar.itemPositioning = .centered
    tabBar.itemSpacing = CGFloat(180)
  }

  func configureMiddleButton(in tabBarView: UITabBar) {
    newScheduledAnimeButton.createButton(in: tabBarView)
  }

  func configureMiddleButtonAction(using request: RequestProtocol) {
    newScheduledAnimeButton.configureButtonAction = { [weak self] in
      let newAnimeVC = NewAnimeScreen(requestsManager: request).getRootViewController()
      self?.present(newAnimeVC, animated: true)
    }
  }
}
