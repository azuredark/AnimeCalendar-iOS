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
    var animeCharactersObservable: Driver<CharacterData?> { get }
    var didFinishLoadingTrailerObservable: Driver<(Bool, Anime)> { get }
    
    func updateAnime(with anime: Anime)
    func updateCharacters(animeId: Int)
    func cleanRequests()
}

final class AnimeDetailInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let animeStorage = BehaviorRelay<Anime>(value: Anime())
    private let charactersStorage = PublishRelay<CharacterData?>()

    private let animeTrailerLoaded = PublishRelay<Bool>()
    private let didFinishLoadingTrailer = BehaviorRelay<((Bool, Anime))>(value: (false, Anime()))

    private var disposeBag = DisposeBag()
    private lazy var requestDisposeBag = DisposeBag()

    // MARK: Initializers
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .animeDetailScreen())
        
        bindTrailerLoaded()
    }

    private func bindTrailerLoaded() {
        animeTrailerLoaded.asObservable().withLatestFrom(animeStorage.asObservable()) { trailerDidLoad, anime in
            return (trailerDidLoad, anime)
        }
        .filter { $0.0 && $0.1.detailFeedSection != .unknown }
        .bind(to: didFinishLoadingTrailer)
        .disposed(by: disposeBag)
    }
}

extension AnimeDetailInteractor: AnimeDetailInteractive {
    var animeObservable: Driver<Anime> {
        animeStorage.asDriver(onErrorJustReturn: Anime())
    }

    var animeTrailerLoadedObservable: PublishRelay<Bool> {
        animeTrailerLoaded
    }

    var animeCharactersObservable: Driver<CharacterData?> {
        charactersStorage.asDriver(onErrorJustReturn: CharacterData())
    }
    
    var didFinishLoadingTrailerObservable: Driver<(Bool, Anime)> {
        didFinishLoadingTrailer.skip(1).asDriver(onErrorJustReturn: (false, Anime()))
    }

//    #error("WHEN REQUESTING FAST THE VIEW MAY HAVE BEEN DESTROYED AND RE-OPENED, OLD EVENTS ARE QUEING UP")
    func updateAnime(with anime: Anime) {
        animeStorage.accept(anime)
    }

//    #error("WHEN REQUESTING FAST THE VIEW MAY HAVE BEEN DESTROYED AND RE-OPENED, OLD EVENTS ARE QUEING UP")
    func updateCharacters(animeId: Int) {
        // Send empty event for loading
        repository.getAnimeCharacters(animeId: animeId)
            .asObservable()
            .bind(to: charactersStorage)
            .disposed(by: requestDisposeBag)
    }
    
    func cleanRequests() {
       requestDisposeBag = DisposeBag()
    }
}
