//
//  DiscoverRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import Foundation

protocol DiscoverRoutable {
    func start(presenter: DiscoverPresentable) -> Screen
}

final class DiscoverRouter {
    // MARK: State
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
}

extension DiscoverRouter: DiscoverRoutable {
    /// Creates the DiscoverScreen.
    /// - Parameter presenter: Home's presenter.
    /// - Returns: Screen
    func start(presenter: DiscoverPresentable) -> Screen {
       return DiscoverScreen(presenter: presenter)
    }
}
