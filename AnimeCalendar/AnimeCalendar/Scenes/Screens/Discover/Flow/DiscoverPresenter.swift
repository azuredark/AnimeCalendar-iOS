//
//  DiscoverPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit
import RxRelay

protocol DiscoverPresentable: NSObject {
    var feedView: Feed? { get set }
    
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
    var recievedValidAnime: PublishRelay<Bool> { get }
    func addLoaderItems()
    func resetAllAnimeData()
}

final class DiscoverPresenter: NSObject {
    // MARK: State
    /// # Interactor
    private let interactor: DiscoverInteractive
    /// # Router
    private let router: DiscoverRoutable
    weak var view: Screen?
    weak var feedView: Feed?

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

    var feed: DiscoverFeed { interactor.feed }
    
    var recievedValidAnime: PublishRelay<Bool> { interactor.recievedValidAnime }

    func updateSeasonAnime() {
        interactor.updateSeasonAnime()
    }

    func updateRecentPromosAnime() {
        interactor.updateRecentPromosAnime()
    }

    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag] {
        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
            let tags = self?.interactor.getTags(episodes: episodes, score: score, rank: rank)
            guard let tags = tags else { return [AnimeTag]() }
            return tags
        }
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
    
    func addLoaderItems() {
        Task(priority: .userInitiated) {
            await interactor.addLoaderItems(in: .animeSeason, for: Anime.self)
            await interactor.addLoaderItems(in: .animePromos, for: Promo.self)
            await interactor.addLoaderItems(in: .animeTop, for: Anime.self)
        }
    }
    
    func resetAllAnimeData() {
        interactor.resetAllAnimeData()
    }
}
