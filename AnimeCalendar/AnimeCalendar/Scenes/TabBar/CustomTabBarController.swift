//
//  CustomTabBarController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomTabBarController: UITabBarController {
  /// # Overriding properties
  var middleButton = UIButton()

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
    tabBar.backgroundColor = Color.white
    tabBar.unselectedItemTintColor = Color.lightGray
    tabBar.tintColor = Color.cobalt

    let scheduledAnimeButton = NewScheduledAnimeButton(tabBar)
    scheduledAnimeButton.configureScheduledAnimeButton()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    print("DID AWAKE FROM NIB")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    middleButton.center = CGPoint(x: tabBar.frame.width / 2, y: -5)
  }
}
