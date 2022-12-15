//
//  DiscoverInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import RxSwift
import RxCocoa

typealias DiscoverFeed = (
    seasonAnime: (driver: Driver<[Anime]>, section: FeedSection),
    recentPromosAnime: (driver: Driver<[Promo]>, section: FeedSection),
    topAnime: (driver: Driver<[Anime]>, section: FeedSection)
)

protocol DiscoverInteractive {
    var feed: DiscoverFeed { get }
    func updateSeasonAnime()
    func updateRecentPromosAnime()
    func updateTopAnime(by order: AnimeOrderType)
    func getImageResource(path: String, completion: @escaping ImageSetting)
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag]
}

final class DiscoverInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let disposeBag = DisposeBag()

    /// # Observables
    #warning("Fill the default value with placholders to give the loading impression")
    private let seasonAnimeObservable = BehaviorRelay<[Anime]>(value: [])
    private let recentPromosAnimeObservable = BehaviorRelay<[Promo]>(value: [])
    private let topAnimeObservable = BehaviorRelay<[Anime]>(value: [])
}

extension DiscoverInteractor: DiscoverInteractive {
    func updateSeasonAnime() {
        repository.getSeasonAnime()
            .compactMap { $0 }
            .map { $0.data }
            .bind(to: seasonAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateRecentPromosAnime() {
        repository.getRecentPromos()
            .compactMap { $0 }
            .map { $0.promos }
            .bind(to: recentPromosAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateTopAnime(by order: AnimeOrderType) {
        repository.getTopAnime(by: order)
            .compactMap { $0 }
            .map { $0.data }
            .bind(to: topAnimeObservable)
            .disposed(by: disposeBag)
    }

    /// Tuple representing each tag's with its priority.
    typealias TagPriority = (tag: AnimeTag, priority: Int)

    /// Creates a list of AnimeTag, sorted by priority, checking its *episodes*, *score* and *rank*.
    ///
    /// The **priority** is pre-defined following the UI conventions order, which is as follows (Top-Bottom):
    /// 1. Episode Tag
    /// 2. Score Tag
    /// 3. Rank Tag
    /// - Parameter episodes: The anime's episodes count.
    /// - Parameter score: The anime's score.
    /// - Parameter rank: The anime's rank.
    /// - Returns: List of sorted **[AnimeTag]** by priority
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag] {
        var tagPriority: [TagPriority] = []

        if let episodes = episodes, episodes > 0 {
            tagPriority.append((tag: .episodes(value: episodes), priority: 1))
        }

        if let score = score {
            tagPriority.append((tag: .score(value: score), priority: 2))
        }

        if let rank = rank {
            tagPriority.append((tag: .rank(value: rank), priority: 3))
        }

        let sortedTags = tagPriority.sorted { $0.priority < $1.priority }
            .map { $0.tag }

        return sortedTags
    }

    var feed: DiscoverFeed {
        return (
            seasonAnime: (driver: seasonAnimeObservable.asDriver(), section: .animeSeason),
            recentPromosAnime: (driver: recentPromosAnimeObservable.asDriver(), section: .animePromos),
            topAnime: (driver: topAnimeObservable.asDriver(), section: .animeTop)
        )
    }
}
