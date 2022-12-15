//
//  CalendarModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

final class CalendarModule {
    // MARK: State
    private let presenter: CalendarPresentable

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let interactor = CalendarInteractor(animeRepository: animeRepository)
        let router = CalendarRouter()
        self.presenter = CalendarPresenter(interactor: interactor, router: router)
    }
}

extension CalendarModule {
    /// Initiates and returns the CalendarScreen (UIViewController)
    /// - Returns: Screen
    func start() -> Screen {
        presenter.start()
    }
}
