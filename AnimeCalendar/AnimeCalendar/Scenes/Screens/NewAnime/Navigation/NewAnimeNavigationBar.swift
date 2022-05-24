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
//    let configuration = UIImage.SymbolConfiguration(weight: .heavy)
    let attributedText: [NSAttributedString.Key: Any] = itemTitleAttributes()

    // NavigationItem
    let settingsItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissScreen))
    settingsItem.setTitleTextAttributes(attributedText, for: .normal)
    settingsItem.setTitleTextAttributes(attributedText, for: .selected)
    let items: [UIBarButtonItem] = [settingsItem]
    screen?.navigationItem.leftBarButtonItems = items
  }

  func configureRightNavigationItems() {}
}

// TODO: Attributed Strings should be done via utils/extension
private extension NewAnimeNavigationBar {
  func itemTitleAttributes() -> [NSAttributedString.Key: Any] {
    let underlineTextAttribute: Int = 1
    let foregroundColorTextAttribute: UIColor = Color.black
    let fontStyleTextAttribute: UIFont = .boldSystemFont(ofSize: 18)

    let textAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: foregroundColorTextAttribute,
      .font: fontStyleTextAttribute,
      .underlineStyle: underlineTextAttribute
    ]

    return textAttributes
  }

  @objc
  func dismissScreen() {
    screen?.dismiss(animated: true)
  }
}
