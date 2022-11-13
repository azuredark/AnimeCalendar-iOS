//
//  DiscoverModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import Foundation

final class DiscoverModule {
    // MARK: State
    private let presenter: DiscoverPresentable
    
    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let interacor = DiscoverInteractor(animeRepository: animeRepository)
        let router = DiscoverRouter()
        presenter = DiscoverPresenter(interactor: interacor, router: router)
    }
    
    // MARK: Methods
    /// Initiates and returns the DiscoverScreen (UIViewController)
    /// - Returns: Screen
    func start() -> Screen {
        presenter.start()
    }
}
