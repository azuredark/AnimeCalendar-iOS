//
//  DiscoverInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import Foundation

protocol DiscoverInteractive {}

final class DiscoverInteractor {
    // MARK: State
    private let animeRepository: AnimeRepository

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }

    // MARK: Methods
}

extension DiscoverInteractor: DiscoverInteractive {}
