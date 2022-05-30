//
//  HomeScreenNavigationBar.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import UIKit

final class HomeScreenNavigationBar: ScreenNavigationBar {
  weak var screen: Screen?
  init(_ screen: Screen) {
    self.screen = screen
  }
}

extension HomeScreenNavigationBar {
  func configureLeftNavigationItems() {
    // Item's image
    let configuration = UIImage.SymbolConfiguration(weight: .heavy)
    var settingsImage = UIImage(systemName: "text.alignleft", withConfiguration: configuration)!.withRenderingMode(.alwaysOriginal)
    settingsImage = settingsImage.withTintColor(Color.black)

    // Navigation item
    let settingsItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)

    let items: [UIBarButtonItem] = [settingsItem]
    screen?.navigationItem.leftBarButtonItems = items
  }

  func configureRightNavigationItems() {
    // Item's image
    let configuration = UIImage.SymbolConfiguration(weight: .heavy)
    var darkModeImage = UIImage(systemName: "circle.righthalf.filled", withConfiguration: configuration)!.withRenderingMode(.alwaysOriginal)
    darkModeImage = darkModeImage.withTintColor(Color.black)

    // Navigation item
    let darkModeItem = UIBarButtonItem(image: darkModeImage, style: .plain, target: self, action: nil)

    let items: [UIBarButtonItem] = [darkModeItem]
    screen?.navigationItem.rightBarButtonItems = items
  }
}
