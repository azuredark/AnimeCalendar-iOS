//
//  NewScheduledAnimeScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

final class NewScheduledAnimeScreen: UIViewController, ScreenProtocol {
  var requestsManager: RequestProtocol
  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: Xibs.newScheduledAnimeScreenView, bundle: Bundle.main)
    configureTabItem()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewScheduledAnimeScreen {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureScreen()
  }
}

extension NewScheduledAnimeScreen {
  func configureScreen() {
    configureNavigationItems()
  }
}

extension NewScheduledAnimeScreen {
  func configureNavigationItems() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    configureLeftNavigationItems()
    configureRightNavigationItems()
  }

  func configureRightNavigationItems() {}

  func configureLeftNavigationItems() {}
}

extension NewScheduledAnimeScreen: RootViewController {
  func getRootViewController() -> UIViewController {
    return CustomNavigationController(self)
  }
}

extension NewScheduledAnimeScreen: ScreenWithTabItem {
  func configureTabItem() {
//    tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
//    tabBarItem.isEnabled = false
  }
}
