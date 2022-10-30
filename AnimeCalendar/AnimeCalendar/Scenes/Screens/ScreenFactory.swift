//
//  ScreenFactory.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

final class ScreenFactory {
    // MARK: State
    private let requestsManager: RequestProtocol

    // MARK: Initializers
    init(_ requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }

    // MARK: Methods
    /// Get Screen type UIViewController.
    /// - Parameter screen: ScreenType to decide which Screen to return.
    /// - Returns: Screen
    func getRootScreen(_ screen: ScreenType) -> Screen {
        switch screen {
            case .homeScreen:
                let homeModule = HomeModule(requestsManager: requestsManager)
                return homeModule.start()
            case .newAnimeScreen:
                let newAnimeModule = NewAnimeModule(requestsManager: requestsManager)
                return newAnimeModule.start()
            case .calendarScreen:
                let calendarModule = CalendarModule(requestsManager: requestsManager)
                return calendarModule.start()
        }
    }
}
