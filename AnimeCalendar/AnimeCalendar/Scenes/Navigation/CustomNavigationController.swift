//
//  CustomNavigationController.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 5/05/22.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    init(_ rootViewController: Screen) {
        super.init(rootViewController: rootViewController)

        /// Settings
        navigationBar.backgroundColor = Color.cream
        
        /// Remove Navigations bar's line (iOS 14 and below)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
