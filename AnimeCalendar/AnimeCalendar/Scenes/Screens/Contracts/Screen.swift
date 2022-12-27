//
//  ScreenProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation
import UIKit.UIViewController

/// # All Screens must conform to `RootViewController`
protocol Screen: UIViewController {
    func configureNavigationItems()
    func configureRightNavigationItems()
    func configureLeftNavigationItems()
}

protocol ScreenWithTabItem: Screen {
    func configureTabItem()
}
