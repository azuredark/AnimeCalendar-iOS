//
//  NavigationBarProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import Foundation

protocol ScreenNavigationBar: AnyObject {
    var screen: Screen? { get }
    func configureTitle()
    func configureTitle(with title: String)
    func configureLeftNavigationItems()
    func configureRightNavigationItems()
}

extension ScreenNavigationBar {
    func configureTitle() {}
    func configureTitle(with title: String) {}
    func configureLeftNavigationItems() {}
    func configureRightNavigationItems() {}
}
