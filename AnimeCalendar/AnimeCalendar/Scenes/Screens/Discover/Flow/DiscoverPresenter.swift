//
//  DiscoverPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit
import RxRelay
import Nuke

protocol DiscoverPresentable: NSObject {
    var feedView: Feed? { get set }
    var observablesState: [FeedSection: SequenceState] { get }

    func start() -> Screen
    func getImageResource(path: String, completion: @escaping ImageSetting)
    func updateSeasonAnime() async
    func updateUpcomingAnime() async
    func updateRecentPromosAnime() async
    func updateTopAnime(by order: AnimeOrderType) async
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag]
    func didTapSearchButton()
    func getCellItemType(_ item: Content) -> FeedItem
    func loadMoreItems(for section: FeedSection)
    func handlePagination(for section: FeedSection)
    func deleteCache()

    /// Handles **actions** made in the DiscoverScreen.
    /// - Parameter action: Action to execute.
    func handle(action: DiscoverAction)

    var feed: DiscoverFeed { get }
    var recievedValidAnime: PublishRelay<Bool> { get }
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

    var observablesState: [FeedSection: SequenceState] { interactor.observablesState }

    var recievedValidAnime: PublishRelay<Bool> { interactor.recievedValidAnime }

    func updateSeasonAnime() async {
        guard interactor.checkSectionState(.animeSeason, not: .requesting) else { return }
        interactor.addLoaderItems(in: .animeSeason)
        interactor.updateSeasonAnime(page: 1)
    }

    func updateUpcomingAnime() async {
        guard interactor.checkSectionState(.animeUpcoming, not: .requesting) else { return }
        interactor.addLoaderItems(in: .animeUpcoming)
        interactor.updateUpcomingAnime(page: 1)
    }

    func updateRecentPromosAnime() async {
        guard interactor.checkSectionState(.animePromos, not: .requesting) else { return }
        interactor.addLoaderItems(in: .animePromos)
        interactor.updateRecentPromosAnime(page: 1)
    }

    func updateTopAnime(by order: AnimeOrderType) async {
        guard interactor.checkSectionState(.animeTop, not: .requesting) else { return }
        interactor.addLoaderItems(in: .animeTop)
        interactor.updateTopAnime(by: order, page: 1)
    }

    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag] {
        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
            let tags = self?.interactor.getTags(episodes: episodes, score: score, rank: rank)
            guard let tags = tags else { return [AnimeTag]() }
            return tags
        }
    }

    func didTapSearchButton() {
        CacheManager.shared.getCache(from: .discoverScreen)?.deleteAllObjects()
    }

    func handle(action: DiscoverAction) {
        router.handle(action: action)
    }

    func resetAllAnimeData() {
        interactor.resetAllAnimeData()
    }

    func getCellItemType(_ item: Content) -> FeedItem {
        if item is LoadingPlaceholder { return .loader }
        return .content
    }

    func loadMoreItems(for section: FeedSection) {
        interactor.loadMoreItems(in: section)
    }

    func handlePagination(for section: FeedSection) {
        // Start pagination.
        if let state = observablesState[section], state != .requesting {
            loadMoreItems(for: section)
        }
    }

    func deleteCache() {
        ImagePipeline.shared.cache.removeAll(caches: .all)
    }
}

private extension DiscoverPresenter {}
