//
//  BootManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class BootManager {
    // MARK: Methods
    func getRootController(_ rootViewControllerType: RootControllerType) -> RootViewController {
        let rootControllerFactory = RootControllerFactory()
        let rootController = rootControllerFactory.getRootController(type: rootViewControllerType)
        return rootController
    }
}
