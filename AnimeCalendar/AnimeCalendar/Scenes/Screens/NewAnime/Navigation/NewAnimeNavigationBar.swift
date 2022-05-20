//
//  NewAnimeNavigationBar.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 19/05/22.
//

import Foundation
import UIKit

final class NewAnimeNavigationBar: ScreenNavigationBar {
  /// # Properties
  weak var screen: ScreenProtocol?

  /// # Init
  init(_ screen: ScreenProtocol) {
    self.screen = screen
  }
}

extension NewAnimeNavigationBar {
  func configureLeftNavigationItems() {
    // Item configuration
    let configuration = UIImage.SymbolConfiguration(weight: .heavy)

    // NavigationItem
    let settingsItem = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    let items: [UIBarButtonItem] = [settingsItem]
    screen?.navigationItem.leftBarButtonItems = items
  }

  func configureRightNavigationItems() {}
}
