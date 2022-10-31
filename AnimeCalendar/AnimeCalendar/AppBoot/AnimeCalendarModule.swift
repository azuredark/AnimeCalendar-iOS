//
//  AnimeCalendarModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol AnimeCalendarModular {
   func getHomeModule() -> HomeModule
   func getNewAnimeModule() -> NewAnimeModule
   func getCalendarModule() -> CalendarModule
}

final class AnimeCalendarModule {
    // MARK: State
    private lazy var requestsManager = RequestsManager()

    /// # Singleton instance
    static let shared = AnimeCalendarModule()

    /// # Modules
    private lazy var homeModule = HomeModule(requestsManager: requestsManager)
    private lazy var newAnimeModule = NewAnimeModule(requestsManager: requestsManager)
    private lazy var calendarModule = CalendarModule(requestsManager: requestsManager)

    // MARK: Initializers
    private init() {}
}

extension AnimeCalendarModule: AnimeCalendarModular {
    func getHomeModule() -> HomeModule { homeModule }

    func getNewAnimeModule() -> NewAnimeModule { newAnimeModule }

    func getCalendarModule() -> CalendarModule { calendarModule }
}
