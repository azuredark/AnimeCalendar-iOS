//
//  AnimeDetailInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxSwift
import RxCocoa

protocol AnimeDetailInteractive {
    func updateAnime(with anime: Anime)
    var animeObservable: Driver<Anime> { get }
    var animeTrailerLoadedObservable: PublishRelay<Bool> { get }
    var didFinishLoadingTrailerObservable: Driver<(Anime, Bool)> { get }
}

final class AnimeDetailInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let animeStorage = BehaviorRelay<Anime>(value: Anime())
    private let animeTrailerLoaded = PublishRelay<Bool>()
    private let didFinishLoadingTrailer = PublishRelay<(Anime, Bool)>()
    
    private let disposeBag = DisposeBag()

    // MARK: Initializers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .animeDetailScreen())
        bindTrailerLoaded()
    }

    // MARK: Methods
    func updateAnime(with anime: Anime) {
        animeStorage.accept(anime)
    }
    
    func bindTrailerLoaded() {
        Observable.zip(animeStorage.asObservable(), animeTrailerLoaded.asObservable())
            .filter { $1 }
            .asDriver(onErrorJustReturn: (Anime(), false))
            .drive(onNext: { [weak self] (anime, didLoad) in
                guard let self = self else { return }
                self.didFinishLoadingTrailer.accept((anime, true))
            }).disposed(by: disposeBag)
    }
}

extension AnimeDetailInteractor: AnimeDetailInteractive {
    var animeObservable: Driver<Anime> {
        return animeStorage.asDriver(onErrorJustReturn: Anime())
    }
    
    var animeTrailerLoadedObservable: PublishRelay<Bool> {
        return animeTrailerLoaded
    }
    
    var didFinishLoadingTrailerObservable: Driver<(Anime, Bool)> {
        return didFinishLoadingTrailer.asDriver(onErrorJustReturn: (Anime(), false))
    }
}
