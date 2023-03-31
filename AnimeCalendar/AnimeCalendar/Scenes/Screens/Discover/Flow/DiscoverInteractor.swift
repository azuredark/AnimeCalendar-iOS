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
    seasonAnime: (observable: Observable<[Content]>, section: FeedSection),
    upcomingAnime: (observable: Observable<[Content]>, section: FeedSection),
    recentPromosAnime: (observable: Observable<[Content]>, section: FeedSection),
    topAnime: (observable: Observable<[Content]>, section: FeedSection)
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
    func addLoaderItems(in section: FeedSection) async
    func resetAllAnimeData()
    func loadMoreItems(in section: FeedSection)
}

final class DiscoverInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let disposeBag = DisposeBag()

    /// # Observables
    private let seasonAnimeObservable = BehaviorRelay<JikanResult<Content>>(value: JikanResult<Content>())
    private let upcomingAnimeObservable = BehaviorRelay<JikanResult<Content>>(value: JikanResult<Content>())
    private let recentPromosAnimeObservable = BehaviorRelay<JikanResult<Content>>(value: JikanResult<Content>())
    private let topAnimeObservable = BehaviorRelay<JikanResult<Content>>(value: JikanResult<Content>())

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
                let season = $0.0.first(where: { $0 is LoadingPlaceholder })
                if season == nil { return Observable.just(true) }

                let upcoming = $0.1.first(where: { $0 is LoadingPlaceholder })
                if upcoming == nil { return Observable.just(true) }

                let promos = $0.2.first(where: { $0 is LoadingPlaceholder })
                if promos == nil { return Observable.just(true) }

                let top = $0.3.first(where: { $0 is LoadingPlaceholder })
                if top == nil { return Observable.just(true) }

                return Observable.just(false)
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
            .compactMap { $0 }
            .flatMapLatest(resultToContent)
            .bind(to: seasonAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateUpcomingAnime(page: Int = 1) {
        updateSequenceState(.animeUpcoming, to: .requesting)
        repository.getUpcomingSeasonAnime(page: page)
            .asObservable()
            .compactMap { $0 }
            .flatMapLatest(resultToContent)
            .bind(to: upcomingAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateRecentPromosAnime(page: Int = 1) {
        updateSequenceState(.animePromos, to: .requesting)
        repository.getRecentPromos(page: page)
            .asObservable()
            .compactMap { $0 }
            .flatMapLatest(resultToContent)
            .bind(to: recentPromosAnimeObservable)
            .disposed(by: disposeBag)
    }

    func updateTopAnime(by order: AnimeOrderType, page: Int = 1) {
        updateSequenceState(.animeTop, to: .requesting)
        repository.getTopAnime(by: order, page: page)
            .asObservable()
            .compactMap { $0 }
            .flatMapLatest(resultToContent)
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
            seasonAnime: (observable: seasonAnimeObservable.map(\.data), section: .animeSeason),
            upcomingAnime: (observable: upcomingAnimeObservable.map(\.data), section: .animeUpcoming),
            recentPromosAnime: (observable: recentPromosAnimeObservable.map(\.data), section: .animePromos),
            topAnime: (observable: topAnimeObservable.map(\.data), section: .animeTop)
        )
    }

    var observablesState: [FeedSection: ObservableState] { sequencesState }

    var recievedValidAnime: PublishRelay<Bool> { recievedValidAnimeObservable }

    func addLoaderItems(in section: FeedSection) async {
        let loaders = createLoaders(in: section)
        let result = JikanResult<Content>(data: loaders)
        switch section {
            case .animeSeason:
                seasonAnimeObservable.accept(result)
            case .animeUpcoming:
                upcomingAnimeObservable.accept(result)
            case .animePromos:
                recentPromosAnimeObservable.accept(result)
            case .animeTop:
                topAnimeObservable.accept(result)
            case .unknown: break
        }
    }

    func resetAllAnimeData() {
        seasonAnimeObservable.accept(JikanResult<Content>())
        recentPromosAnimeObservable.accept(JikanResult<Content>())
        topAnimeObservable.accept(JikanResult<Content>())
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
    func createLoaders(in section: FeedSection) -> [LoadingPlaceholder] {
        var loaders = [LoadingPlaceholder]()

        for _ in 0 ..< section.placeholderCount {
            let loader = LoadingPlaceholder()
            loader.feedSection = section

            loaders.append(loader)
        }

        return loaders
    }

    func updateSequenceState(_ section: FeedSection, to state: SequenceState) {
        sequencesState[section]?.state = state
    }

    func resultToContent<T: Content>(_ result: JikanResult<T>) -> Observable<JikanResult<Content>> {
        let content = result.data.compactMap { $0 as Content }
        return Observable.just(JikanResult<Content>(data: content))
    }
}
