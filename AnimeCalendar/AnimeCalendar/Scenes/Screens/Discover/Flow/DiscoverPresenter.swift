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
    func updateTopAnime(by order: AnimeOrderType)
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag]
    func didTapSearchButton()

    /// Handles **actions** made in the DiscoverScreen.
    /// - Parameter action: Action to execute.
    func handle(action: DiscoverAction)
    
    var feed: DiscoverFeed { get }
}

final class DiscoverPresenter: NSObject {
    // MARK: State
    /// # Interactor
    private let interactor: DiscoverInteractive
    /// # Router
    private let router: DiscoverRoutable
    weak var view: Screen?

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

    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag] {
        interactor.getTags(episodes: episodes, score: score, rank: rank)
    }
    
    func updateTopAnime(by order: AnimeOrderType) {
        interactor.updateTopAnime(by: order)
    }
    
    func didTapSearchButton() {
        CacheManager.shared.getCache(from: .discoverScreen)?.deleteAllObjects()
    }
    
    func handle(action: DiscoverAction) {
        router.handle(action: action)
    }
}
