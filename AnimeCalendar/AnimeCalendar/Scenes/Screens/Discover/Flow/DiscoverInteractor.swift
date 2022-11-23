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
    topAnime: (driver: Driver<[Anime]>, section: FeedSection)
)

protocol DiscoverInteractive {
    var feed: DiscoverFeed { get }
    func updateSeasonAnime()
}

final class DiscoverInteractor {
    // MARK: State
    private let animeRepository: AnimeRepository
    private let disposeBag = DisposeBag()

    /// # Observables
    #warning("Fill the default value with placholders to give the loading impression")
    private let seasonAnimeObservable = BehaviorRelay<[Anime]>(value: [])
    private let topAnimeObservable = BehaviorRelay<[Anime]>(value: [])

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }
}

extension DiscoverInteractor: DiscoverInteractive {
    func updateSeasonAnime() {
        animeRepository.getSeasonAnime()
            .compactMap { $0 }
            .map { $0.data }
            .bind(to: seasonAnimeObservable)
            .disposed(by: disposeBag)
    }

    var feed: DiscoverFeed {
        return (
            seasonAnime: (driver: seasonAnimeObservable.asDriver(), section: .seasonAnime),
            topAnime: (driver: topAnimeObservable.asDriver(), section: .topAnime)
        )
    }
}
