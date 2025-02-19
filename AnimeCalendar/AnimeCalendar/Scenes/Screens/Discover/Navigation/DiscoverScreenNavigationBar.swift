//
//  DiscoverScreenNavigationBar.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit

final class DiscoverScreenNavigationBar: ScreenNavigationBar {
    // MARK: State
    weak var screen: Screen?

    // MARK: Initializers
    init(_ screen: Screen) {
        self.screen = screen
    }
}

extension DiscoverScreenNavigationBar {
    func configureTitle() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.black
        ]

        screen?.navigationItem.title = "Discover"
        screen?.navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }

    func configureLeftNavigationItems() {
//        // Item's image
//        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
//        var settingsImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)!.withRenderingMode(.alwaysOriginal)
//        settingsImage = settingsImage.withTintColor(Color.black)
//
//        // Navigation item
//        let settingsItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(dismissScreen))
//
//        let items: [UIBarButtonItem] = [settingsItem]
//        screen?.navigationItem.leftBarButtonItems = items
    }

    func configureRightNavigationItems() {
//        // Item's image
//        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
//        var settingsImage: UIImage
//
//        if #available(iOS 15.0, *) {
//            settingsImage = UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration: configuration)!.withRenderingMode(.alwaysOriginal)
//        } else {
//            settingsImage = UIImage(systemName: "slider.horizontal.3", withConfiguration: configuration)!.withRenderingMode(.alwaysOriginal)
//        }
//
//        settingsImage = settingsImage.withTintColor(Color.black)
//
//        // Navigation item
//        let settingsItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)
//
//        let items: [UIBarButtonItem] = [settingsItem]
//        screen?.navigationItem.rightBarButtonItems = items
    }
}

// TODO: Attributed Strings should be done via utils/extension
private extension DiscoverScreenNavigationBar {
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
