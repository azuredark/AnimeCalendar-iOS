//
//  AnimeDetailInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxSwift
import RxCocoa

protocol AnimeDetailInteractive {
    var animeObservable: Driver<Anime> { get }
    var animeTrailerLoadedObservable: PublishRelay<Bool> { get }
    var animeCharactersObservable: Driver<CharacterData> { get }
    var didFinishLoadingTrailerObservable: Driver<(Anime, Bool)> { get }
    
    func updateAnime(with anime: Anime)
    func updateCharacters(animeId: Int)
    func cleanRequests()
}

final class AnimeDetailInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let animeStorage = BehaviorRelay<Anime>(value: Anime())
    private let charactersStorage = PublishRelay<CharacterData>()

    private let animeTrailerLoaded = PublishRelay<Bool>()
    private let didFinishLoadingTrailer = PublishRelay<(Anime, Bool)>()

    private var disposeBag = DisposeBag()
    private lazy var requestDisposeBag = DisposeBag()

    // MARK: Initializers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .animeDetailScreen())
        
        bindTrailerLoaded()
    }

//    #error("WHEN REQUESTING FAST THE VIEW MAY HAVE BEEN DESTROYED AND RE-OPENED, OLD EVENTS ARE QUEING UP")
    private func bindTrailerLoaded() {
        Observable.zip(animeStorage.asObservable(), animeTrailerLoaded.asObservable())
            .asDriver(onErrorJustReturn: (Anime(), false))
            .drive(onNext: { [weak self] (anime, trailerState) in
                guard let self = self else { return }
                self.didFinishLoadingTrailer.accept((anime, trailerState))
            }).disposed(by: disposeBag)
    }
}

extension AnimeDetailInteractor: AnimeDetailInteractive {
    var animeObservable: Driver<Anime> {
        animeStorage.asDriver(onErrorJustReturn: Anime())
    }

    var animeTrailerLoadedObservable: PublishRelay<Bool> {
        animeTrailerLoaded
    }

    var animeCharactersObservable: Driver<CharacterData> {
        charactersStorage.asDriver(onErrorJustReturn: CharacterData())
    }
    
    var didFinishLoadingTrailerObservable: Driver<(Anime, Bool)> {
        didFinishLoadingTrailer.asDriver(onErrorJustReturn: (Anime(), false))
    }

//    #error("WHEN REQUESTING FAST THE VIEW MAY HAVE BEEN DESTROYED AND RE-OPENED, OLD EVENTS ARE QUEING UP")
    func updateAnime(with anime: Anime) {
        animeStorage.accept(anime)
    }

//    #error("WHEN REQUESTING FAST THE VIEW MAY HAVE BEEN DESTROYED AND RE-OPENED, OLD EVENTS ARE QUEING UP")
    func updateCharacters(animeId: Int) {
        // Send empty event for loading
        repository.getAnimeCharacters(animeId: animeId)
            .compactMap { $0 }
            .bind(to: charactersStorage)
            .disposed(by: requestDisposeBag)
    }
    
    func cleanRequests() {
       requestDisposeBag = DisposeBag()
    }
}
