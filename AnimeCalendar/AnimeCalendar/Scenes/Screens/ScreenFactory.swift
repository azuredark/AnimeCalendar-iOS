//
//  ScreenFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

final class ScreenFactory {
    // MARK: Methods
    /// Get Screen type UIViewController.
    /// - Parameter screen: ScreenType to decide which Screen to return.
    /// - Returns: Screen
    func getModuleBaseController(_ screen: ScreenType) -> CustomNavigationController {
        switch screen {
            case .homeScreen:
                let homeModule = AnimeCalendarModule.shared.getHomeModule()
                return homeModule.start()
            case .newAnimeScreen:
                let newAnimeModule = AnimeCalendarModule.shared.getNewAnimeModule()
                return newAnimeModule.start()
            case .calendarScreen:
                let calendarModule = AnimeCalendarModule.shared.getCalendarModule()
                return calendarModule.start()
            case .discoverScreen:
                let discoverModule = AnimeCalendarModule.shared.getDiscoverModule()
                return discoverModule.start()
            case .animeDetailScreen:
                let animeDetailModule = AnimeCalendarModule.shared.getAnimeDetailModule()
                return animeDetailModule.start()
        }
    }
}
