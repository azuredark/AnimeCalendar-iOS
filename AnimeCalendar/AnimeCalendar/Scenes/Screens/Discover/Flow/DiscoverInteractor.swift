//
//  DiscoverInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import RxSwift
import RxCocoa

enum SequenceState {
    case initial
    case requesting
    case completed
    case error
}

typealias FeedSectionsState = [FeedSection: ObservableState]
typealias ObservableState = (observable: any ObservableType, state: SequenceState)

typealias DiscoverFeed = (
    seasonAnime: (observable: Observable<[Anime]>, section: FeedSection),
    upcomingAnime: (observable: Observable<[Anime]>, section: FeedSection),
    recentPromosAnime: (observable: Observable<[Promo]>, section: FeedSection),
    topAnime: (observable: Observable<[Anime]>, section: FeedSection)
)

protocol DiscoverInteractive {
    var feed: DiscoverFeed { get }
    var recievedValidAnime: PublishRelay<Bool> { get }
    var observablesState: [FeedSection: ObservableState] { get }

    func updateSeasonAnime(page: Int)
    func updateUpcomingAnime(page: Int)
    func updateRecentPromosAnime(page: Int)
    func updateTopAnime(by order: AnimeOrderType, page: Int)
    
    func getImageResource(path: String, completion: @escaping ImageSetting)
    func getTags(episodes: Int?, score: CGFloat?, rank: Int?) -> [AnimeTag]
    func addLoaderItems<T: ModelSectionable>(in section: FeedSection, for mode: T.Type) async
    func resetAllAnimeData()
    func loadMoreItems(in section: FeedSection)
}

final class DiscoverInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let disposeBag = DisposeBag()

    /// # Observables
    private let seasonAnimeObservable = BehaviorRelay<JikanResult<Anime>>(value: JikanResult<Anime>())
    private let upcomingAnimeObservable = BehaviorRelay<JikanResult<Anime>>(value: JikanResult<Anime>())
    private let recentPromosAnimeObservable = BehaviorRelay<JikanResult<Promo>>(value: JikanResult<Promo>())
    private let topAnimeObservable = BehaviorRelay<JikanResult<Anime>>(value: JikanResult<Anime>())

    private let recievedValidAnimeObservable = PublishRelay<Bool>()

    private lazy var sequencesState: [FeedSection: ObservableState] = [
        .animeSeason: (observable: seasonAnimeObservable, state: .initial),
        .animeUpcoming: (observable: upcomingAnimeObservable, state: .initial),
        .animePromos: (observable: recentPromosAnimeObservable, state: .initial),
        .animeTop: (observable: topAnimeObservable, state: .initial)
    ]

    /// # Initalizers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .discoverScreen)
        bindRecievedAtLeastOneResponse()
    }
}

extension DiscoverInteractor {
    func bindRecievedAtLeastOneResponse() {
        Observable.combineLatest(seasonAnimeObservable.map(\.data).asObservable(),
                                 upcomingAnimeObservable.map(\.data).asObservable(),
                                 recentPromosAnimeObservable.map(\.data).asObservable(),
                                 topAnimeObservable.map(\.data).asObservable())
            // Ignore if any of them is empty.
            .filter { !($0.0.isEmpty || $0.1.isEmpty || $0.2.isEmpty || $0.3.isEmpty) }

            // If one of them returns a value then transform to true and update.
            .flatMapLatest {
                let result: Bool = false

                let season = $0.0.first(where: { $0.isLoading })
                if season == nil { return Observable.just(true) }

                let upcoming = $0.1.first(where: { $0.isLoading })
                if upcoming == nil { return Observable.just(true) }

                let promos = $0.2.first(where: { $0.isLoading })
                if promos == nil { return Observable.just(true) }

                let top = $0.3.first(where: { $0.isLoading })
                if top == nil { return Observable.just(true) }

                return Observable.just(result)
            }
            .asObservable()
            .bind(to: recievedValidAnimeObservable)
            .disposed(by: disposeBag)
    }
}

extension DiscoverInteractor: DiscoverInteractive, ReactiveCompatible {
    func updateSeasonAnime(page: Int = 1) {
        updateSequenceState(.animeSeason, to: .requesting)
        repository.getSeasonAnime(page: page)
            .asObservable()
            .bind(to: rx.addLoadMoreItem(in: .animeSeason, model: Anime.self))
            .disposed(by: disposeBag)
    }

    func updateUpcomingAnime(page: Int = 1) {
        updateSequenceState(.animeUpcoming, to: .requesting)
        repository.getUpcomingSeasonAnime(page: page)
            .asObservable()
            .bind(to: rx.addLoadMoreItem(in: .animeUpcoming, model: Anime.self))
            .disposed(by: disposeBag)
    }

    func updateRecentPromosAnime(page: Int = 1) {
        updateSequenceState(.animePromos, to: .requesting)
        repository.getRecentPromos(page: page)
            .asObservable()
            .bind(to: rx.addLoadMoreItem(in: .animePromos, model: Promo.self))
            .disposed(by: disposeBag)
    }

    func updateTopAnime(by order: AnimeOrderType, page: Int = 1) {
        updateSequenceState(.animeTop, to: .requesting)
        repository.getTopAnime(by: order, page: page)
            .asObservable()
            .bind(to: rx.addLoadMoreItem(in: .animeTop, model: Anime.self))
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
            seasonAnime: (observable: seasonAnimeObservable.map(\.data), section: .animeSeason),
            upcomingAnime: (observable: upcomingAnimeObservable.map(\.data), section: .animeUpcoming),
            recentPromosAnime: (observable: recentPromosAnimeObservable.map(\.data), section: .animePromos),
            topAnime: (observable: topAnimeObservable.map(\.data), section: .animeTop)
        )
    }

    var observablesState: [FeedSection: ObservableState] { sequencesState }

    var recievedValidAnime: PublishRelay<Bool> { recievedValidAnimeObservable }

    func addLoaderItems<T: ModelSectionable>(in section: FeedSection, for model: T.Type) async {
        switch section {
            case .animeSeason:
                let loaders = createLoaders(of: Anime.self, in: .animeSeason)
                seasonAnimeObservable.accept(JikanResult<Anime>(data: loaders))
            case .animeUpcoming:
                let loaders = createLoaders(of: Anime.self, in: .animeUpcoming)
                upcomingAnimeObservable.accept(JikanResult<Anime>(data: loaders))
            case .animePromos:
                let loaders = createLoaders(of: Promo.self, in: .animePromos)
                recentPromosAnimeObservable.accept(JikanResult<Promo>(data: loaders))
            case .animeTop:
                let loaders = createLoaders(of: Anime.self, in: .animeTop)
                topAnimeObservable.accept(JikanResult<Anime>(data: loaders))
            case .unknown: break
        }
    }

    #warning("Optimize & Clean this code u.u")
    func addLoadMoreItem<T: ModelSectionable & Decodable>(in section: FeedSection, for model: T.Type, result: JikanResult<T>, hasNextPage: Bool) {
        updateSequenceState(section, to: .completed)
        switch section {
            case .animeSeason:
                guard let loadMoreItem = createLoadMoreItem(of: Anime.self, in: .animeSeason) else { return }
                guard let newItems = result.data as? [Anime] else { return }

                var newData = seasonAnimeObservable.value.data.filter { !($0.isLoading || $0.isLoadMoreItem) } + newItems
                if hasNextPage { newData += [loadMoreItem] }
                seasonAnimeObservable.accept(JikanResult<Anime>(data: newData,
                                                                pagination: JikanPagination(hasNextPage: hasNextPage, page: result.pagination.page)))
            case .animeUpcoming:
                guard let loadMoreItem = createLoadMoreItem(of: Anime.self, in: .animeUpcoming) else { return }
                guard let newItems = result.data as? [Anime] else { return }

                var newData = upcomingAnimeObservable.value.data.filter { !($0.isLoading || $0.isLoadMoreItem) } + newItems
                if hasNextPage { newData += [loadMoreItem] }
                upcomingAnimeObservable.accept(JikanResult<Anime>(data: newData,
                                                                  pagination: JikanPagination(hasNextPage: hasNextPage, page: result.pagination.page)))
            case .animePromos:
                guard let loadMoreItem = createLoadMoreItem(of: Promo.self, in: .animePromos) else { return }
                guard let newItems = result.data as? [Promo] else { return }

                var newData = recentPromosAnimeObservable.value.data.filter { !($0.isLoading || $0.isLoadMoreItem) } + newItems
                if hasNextPage { newData += [loadMoreItem] }
                recentPromosAnimeObservable.accept(JikanResult<Promo>(data: newData,
                                                                      pagination: JikanPagination(hasNextPage: hasNextPage, page: result.pagination.page)))
            case .animeTop:
                guard let loadMoreItem = createLoadMoreItem(of: Anime.self, in: .animeTop) else { return }
                guard let newItems = result.data as? [Anime] else { return }
                var newData = topAnimeObservable.value.data.filter { !($0.isLoading || $0.isLoadMoreItem) } + newItems

                if hasNextPage { newData += [loadMoreItem] }
                topAnimeObservable.accept(JikanResult<Anime>(data: newData,
                                                             pagination: JikanPagination(hasNextPage: hasNextPage, page: result.pagination.page)))
            case .unknown: break
        }
    }

    func resetAllAnimeData() {
        seasonAnimeObservable.accept(JikanResult<Anime>())
        recentPromosAnimeObservable.accept(JikanResult<Promo>())
        topAnimeObservable.accept(JikanResult<Anime>())
        recievedValidAnimeObservable.accept(false)
    }

    func loadMoreItems(in section: FeedSection) {
        switch section {
            case .animeSeason:
                let currentValue = seasonAnimeObservable.value
                guard currentValue.pagination.hasNextPage else { return }
                updateSeasonAnime(page: currentValue.pagination.page + 1)
            case .animeUpcoming:
                let currentValue = upcomingAnimeObservable.value
                guard currentValue.pagination.hasNextPage else { return }
                updateUpcomingAnime(page: currentValue.pagination.page + 1)
            case .animePromos:
                let currentValue = recentPromosAnimeObservable.value
                guard currentValue.pagination.hasNextPage else { return }
                updateRecentPromosAnime(page: currentValue.pagination.page + 1)
            case .animeTop:
                let currentValue = topAnimeObservable.value
                guard currentValue.pagination.hasNextPage else { return }
                updateTopAnime(by: .rank, page: topAnimeObservable.value.pagination.page + 1)
            case .unknown: break
        }
    }
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

    func createLoadMoreItem<T: ModelSectionable>(of type: T.Type, in section: FeedSection) -> T? {
        var loadMoreItem: T? = Anime() as? T

        if type is Anime.Type {
            loadMoreItem = Anime() as? T
        } else if type is Promo.Type {
            loadMoreItem = Promo() as? T
        }

        loadMoreItem?.feedSection = section
        loadMoreItem?.isLoadMoreItem = true

        return loadMoreItem
    }

    func updateSequenceState(_ section: FeedSection, to state: SequenceState) {
        sequencesState[section]?.state = state
    }
}

extension Reactive where Base: DiscoverInteractor {
    func addLoadMoreItem<T: ModelSectionable>(in section: FeedSection, model: T.Type) -> Binder<JikanResult<T>?> {
        return Binder<JikanResult<T>?>(self.base, binding: { interactor, result in
            guard let result else { return }
            interactor.addLoadMoreItem(in: section, for: model, result: result, hasNextPage: result.pagination.hasNextPage)
        })
    }
}
