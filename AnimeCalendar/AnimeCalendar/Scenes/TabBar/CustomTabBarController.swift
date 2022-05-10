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
    delegate = self
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
    newScheduledAnimeButton.configureButtonAction = { [weak self] in
      self?.selectedIndex = 1
    }
  }
}

// MARK: - Configure NewScheduledAnime "present" animation

extension CustomTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    animateTabBarChange(tabBarController: tabBarController, to: viewController)
    print("Selected VC: \(viewController)")
    return true
  }

  func animateTabBarChange(tabBarController: UITabBarController, to viewController: UIViewController) {
//    guard let newAnimeScreen = tabBarController.viewControllers?[1] as? NewScheduledAnimeScreen else { return }
//    let fromView = newAnimeScreen.getRootViewController().view
//    let toView = viewController.view
  }
}
