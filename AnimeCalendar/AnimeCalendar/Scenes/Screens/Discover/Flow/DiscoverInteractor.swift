//
//  DiscoverInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import RxSwift
import RxCocoa

typealias DiscoverFeed = (
    seasonAnime: (observable: BehaviorRelay<[Anime]>, section: FeedSection),
    recentPromosAnime: (observable: BehaviorRelay<[Promo]>, section: FeedSection),
    topAnime: (observable: BehaviorRelay<[Anime]>, section: FeedSection)
)

protocol DiscoverInteractive {
    var feed: DiscoverFeed { get }
    var recievedValidAnime: PublishRelay<Bool> { get }

    func updateSeasonAnime()
    func updateRecentPromosAnime()
    func updateTopAnime(by order: AnimeOrderType)
    func getImageResource(path: String, completion: @escaping ImageSetting)
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag]
    func addLoaderItems<T: ModelSectionable>(in section: FeedSection, for mode: T.Type) async
    func resetAllAnimeData()
}

final class DiscoverInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let disposeBag = DisposeBag()

    /// # Observables
    private let seasonAnimeObservable = BehaviorRelay<[Anime]>(value: [])
    private let recentPromosAnimeObservable = BehaviorRelay<[Promo]>(value: [])
    private let topAnimeObservable = BehaviorRelay<[Anime]>(value: [])

    private let recievedValidAnimeObservable = PublishRelay<Bool>()

    /// # Initalizers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .discoverScreen)
        bindRecievedAtLeastOneResponse()
    }
}

extension DiscoverInteractor {
    func bindRecievedAtLeastOneResponse() {
        Observable.combineLatest(seasonAnimeObservable.asObservable(),
                                 recentPromosAnimeObservable.asObservable(),
                                 topAnimeObservable.asObservable())
            // Ignore if any of them is empty.
            .filter { !($0.0.isEmpty || $0.1.isEmpty || $0.2.isEmpty) }

            // If one of them returns a value then transform to true and update.
            .flatMapLatest {
                let result: Bool = false

                let season = $0.0.first(where: { $0.isLoading })
                if season == nil { return Observable.just(true) }

                let promos = $0.1.first(where: { $0.isLoading })
                if promos == nil { return Observable.just(true) }

                let top = $0.2.first(where: { $0.isLoading })
                if top == nil { return Observable.just(true) }

                return Observable.just(result)
            }
            .asObservable()
            .bind(to: recievedValidAnimeObservable)
            .disposed(by: disposeBag)
    }
}

extension DiscoverInteractor: DiscoverInteractive {
    func updateSeasonAnime() {
        repository.getSeasonAnime()
            .asObservable()
            .compactMap(\.?.data)
            .bind(to: seasonAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateRecentPromosAnime() {
        repository.getRecentPromos()
            .asObservable()
            .compactMap(\.?.data)
            .bind(to: recentPromosAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateTopAnime(by order: AnimeOrderType) {
        repository.getTopAnime(by: order)
            .asObservable()
            .compactMap(\.?.data)
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
            seasonAnime: (observable: seasonAnimeObservable, section: .animeSeason),
            recentPromosAnime: (observable: recentPromosAnimeObservable, section: .animePromos),
            topAnime: (observable: topAnimeObservable, section: .animeTop)
        )
    }

    var recievedValidAnime: PublishRelay<Bool> { recievedValidAnimeObservable }

    func addLoaderItems<T: ModelSectionable>(in section: FeedSection, for model: T.Type) async {
        switch section {
            case .animeSeason:
                let loaders = createLoaders(of: Anime.self, in: .animeSeason)
                seasonAnimeObservable.accept(loaders)
            case .animePromos:
                let loaders = createLoaders(of: Promo.self, in: .animePromos)
                recentPromosAnimeObservable.accept(loaders)
            case .animeTop:
                let loaders = createLoaders(of: Anime.self, in: .animeTop)
                topAnimeObservable.accept(loaders)
            case .unknown: break
        }
    }

    func resetAllAnimeData() {
        seasonAnimeObservable.accept([])
        recentPromosAnimeObservable.accept([])
        topAnimeObservable.accept([])
        recievedValidAnimeObservable.accept(false)
    }

    #warning("ADD REMOVE LOADERS METHOD")
}

private extension DiscoverInteractor {
    /// Creates loaders of a specfic type.
    func createLoaders<T: ModelSectionable>(of type: T.Type, in section: FeedSection) -> [T] {
        var loaders = [T?]()

        for _ in 0 ..< section.placeholderCount {
            var loader: T?
            if type is Anime.Type {
                loader = Anime() as? T
            } else if type is Promo.Type {
                loader = Promo() as? T
            }

            loader?.isLoading = true
            loader?.feedSection = section
            loaders.append(loader)
        }

        return loaders.compactMap { $0 }
    }
}
