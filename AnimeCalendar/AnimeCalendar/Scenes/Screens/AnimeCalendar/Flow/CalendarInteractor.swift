//
//  CalendarInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol CalendarInteractive {}

final class CalendarInteractor {
    // MARK: State
    private let animeRepository: AnimeRepository

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }

    // MARK: Methods
}

extension CalendarInteractor: CalendarInteractive {}
