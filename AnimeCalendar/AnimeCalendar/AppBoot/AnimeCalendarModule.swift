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

// TODO: Module dependencies should have a dictionary of repositories? Or make them Singletons?
final class AnimeCalendarModule {
    // MARK: State
    private lazy var requestsManager = RequestsManager()
    
    /// # Repositories
    private lazy var animeRepository = AnimeRepository(requestsManager)

    /// # Singleton instance
    static let shared = AnimeCalendarModule()

    /// # Modules
    private lazy var homeModule = HomeModule(animeRepository: animeRepository)
    private lazy var newAnimeModule = NewAnimeModule(animeRepository: animeRepository)
    private lazy var calendarModule = CalendarModule(requestsManager: requestsManager)

    // MARK: Initializers
    private init() {}
}

extension AnimeCalendarModule: AnimeCalendarModular {
    func getHomeModule() -> HomeModule { homeModule }

    func getNewAnimeModule() -> NewAnimeModule { newAnimeModule }

    func getCalendarModule() -> CalendarModule { calendarModule }
}
