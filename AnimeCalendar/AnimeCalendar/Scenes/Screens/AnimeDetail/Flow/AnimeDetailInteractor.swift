//
//  AnimeDetailInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import Foundation

protocol AnimeDetailInteractive {}

final class AnimeDetailInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State

    // MARK: Initializers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .animeDetailScreen)
    }

    // MARK: Methods
}

extension AnimeDetailInteractor: AnimeDetailInteractive {}
