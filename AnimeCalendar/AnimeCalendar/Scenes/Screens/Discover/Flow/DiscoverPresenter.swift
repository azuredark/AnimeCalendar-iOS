//
//  DiscoverPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import Foundation

protocol DiscoverPresentable: NSObject {
    func start() -> Screen
    func updateSeasonAnime()
    var feed: DiscoverFeed { get }
}

final class DiscoverPresenter: NSObject {
    // MARK: State
    /// # Interactor
    private let interactor: DiscoverInteractive
    /// # Router
    private let router: DiscoverRoutable
    
    // MARK: Initializers
    init(interactor: DiscoverInteractive, router: DiscoverRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension DiscoverPresenter: DiscoverPresentable {
    func start() -> Screen {
        router.start(presenter: self)
    }

    func updateSeasonAnime() {
        interactor.updateSeasonAnime()
    }
    
    var feed: DiscoverFeed {
        return interactor.feed
    }
}
