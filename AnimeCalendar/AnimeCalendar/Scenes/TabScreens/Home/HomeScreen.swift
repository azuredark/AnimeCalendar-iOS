//
//  HomeScreenVC.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import UIKit

final class HomeScreen: UIViewController, ScreenProtocol {
  let backgroundColor: UIColor = Color.hex("#F7F5F2")
  // Protocol properties
  var requestsManager: RequestProtocol

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: Xibs.homeScreenView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationItems()
  }
}

extension HomeScreen {
  func configureScreen() {
    configureNavigationItems()
  }

  func configureNavigationItems() {
    configureLeftNavigationItems()
    configureRightNavigationItems()
  }

  func configureLeftNavigationItems() {
    let settingsImage = UIImage(systemName: "text.alignleft")!
    settingsImage.withTintColor(.black)
    let settingsItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)
    settingsItem.image?.withTintColor(.black)
    let items: [UIBarButtonItem] = [settingsItem]
    navigationItem.leftBarButtonItems = items
  }

  func configureRightNavigationItems() {
    let image = UIImage(systemName: "circle.righthalf.filled")!
    let darkModeItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
    let items: [UIBarButtonItem] = [darkModeItem]
    navigationItem.rightBarButtonItems = items
  }
}
