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
    func getImageResource(path: String, completion: @escaping ImageSetting)
}

final class DiscoverInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let disposeBag = DisposeBag()

    /// # Observables
    #warning("Fill the default value with placholders to give the loading impression")
    private let seasonAnimeObservable = BehaviorRelay<[Anime]>(value: [])
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

    var feed: DiscoverFeed {
        return (
            seasonAnime: (driver: seasonAnimeObservable.asDriver(), section: .animeSeason),
            topAnime: (driver: topAnimeObservable.asDriver(), section: .animeTop)
        )
    }
}
