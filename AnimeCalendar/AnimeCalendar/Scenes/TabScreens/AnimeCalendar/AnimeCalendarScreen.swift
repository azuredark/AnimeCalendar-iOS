//
//  AnimeCalendarScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit.UIViewController

final class AnimeCalendarScreen: UIViewController, ScreenProtocol {
  var requestsManager: RequestProtocol

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: Xibs.animeCalendarScreenView, bundle: Bundle.main)
    configureTabItem()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension AnimeCalendarScreen {
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\(self) didLoad")
    configureScreen()
  }
}

extension AnimeCalendarScreen {
  func configureScreen() {
    configureNavigationItems()
  }
}

extension AnimeCalendarScreen {
  func configureNavigationItems() {
    configureRightNavigationItems()
    configureLeftNavigationItems()
  }

  func configureRightNavigationItems() {}

  func configureLeftNavigationItems() {}
}

extension AnimeCalendarScreen: RootViewController {
  func getRootViewController() -> UIViewController {
    return CustomNavigationController(self)
  }
}

extension AnimeCalendarScreen: ScreenWithTabItem {
  func configureTabItem() {
    view.autoresizingMask = .flexibleHeight
    let configuration = UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.bold)
    let tabImage = UIImage(systemName: "calendar", withConfiguration: configuration)!.withBaselineOffset(fromBottom: UIFont.systemFontSize * 1.5)
    tabBarItem = UITabBarItem(title: nil, image: tabImage, selectedImage: tabImage)
  }
}
