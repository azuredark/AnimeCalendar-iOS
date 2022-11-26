//
//  DiscoverPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit

protocol DiscoverPresentable: NSObject {
    func start() -> Screen
    func getImageResource(path: String, completion: @escaping ImageSetting)
    func updateSeasonAnime()
    func updateRecentPromosAnime()
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

    func getImageResource(path: String, completion: @escaping ImageSetting) {
        interactor.getImageResource(path: path, completion: completion)
    }

    var feed: DiscoverFeed {
        return interactor.feed
    }

    func updateSeasonAnime() {
        interactor.updateSeasonAnime()
    }

    func updateRecentPromosAnime() {
        interactor.updateRecentPromosAnime()
    }
}
