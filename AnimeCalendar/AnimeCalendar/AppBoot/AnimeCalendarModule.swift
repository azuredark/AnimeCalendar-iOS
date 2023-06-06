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
    func getDiscoverModule() -> DiscoverModule
    func getAnimeDetailModule(requiresNavigation: Bool) -> AnimeDetailModule
}

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
    private lazy var calendarModule = CalendarModule(animeRepository: animeRepository)
    private lazy var discoverModule = DiscoverModule(animeRepository: animeRepository)

    // MARK: Initializers
    private init() {}
}

extension AnimeCalendarModule: AnimeCalendarModular {
    func getHomeModule() -> HomeModule { homeModule }

    func getNewAnimeModule() -> NewAnimeModule { newAnimeModule }

    func getCalendarModule() -> CalendarModule { calendarModule }
    
    func getDiscoverModule() -> DiscoverModule { discoverModule }
    
    /// This module re-creates on-demand instead of being saved in memory.
    func getAnimeDetailModule(requiresNavigation: Bool = true) -> AnimeDetailModule {
        return AnimeDetailModule(animeRepository: animeRepository, requiresNavigation: requiresNavigation)
    }
}

protocol Modulable {
    associatedtype T
    var presenter: T { get }
    
    func start() -> CustomNavigationController
}
