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
    var animeCharactersObservable: Driver<[CharacterInfo]> { get }
    var animeReviewsObservable: Driver<[ReviewInfo]> { get }
    var animeRecommendationsObservable: Driver<[RecommendationInfo]> { get }
    var didFinishLoadingTrailerObservable: Driver<(Bool, Anime)> { get }
    
    func findAnime(id: Int, detailSection: DetailFeedSection)
    func updateAnime(with anime: Anime)
    func updateCharacters(animeId: Int)
    func updateReviews(animeId: Int)
    func updateRecommendations(animeId: Int)
    
    func cleanRequests()
}

final class AnimeDetailInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    private let animeStorage = BehaviorRelay<Anime>(value: Anime())
    private let charactersStorage = PublishRelay<JikanResult<CharacterInfo>?>()
    private let reviewsStorage = PublishRelay<JikanResult<ReviewInfo>?>()
    private let recommendationsStorage = PublishRelay<JikanResult<RecommendationInfo>?>()

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
        animeStorage.filter { $0.malId != nil } .asDriver(onErrorJustReturn: Anime())
    }

    var animeTrailerLoadedObservable: PublishRelay<Bool> {
        animeTrailerLoaded
    }

    var animeCharactersObservable: Driver<[CharacterInfo]> {
        charactersStorage.compactMap(\.?.data).asDriver(onErrorJustReturn: [])
    }
    
    var animeReviewsObservable: Driver<[ReviewInfo]> {
        reviewsStorage.compactMap(\.?.data).asDriver(onErrorJustReturn: [])
    }
    
    var animeRecommendationsObservable: Driver<[RecommendationInfo]> {
        recommendationsStorage.compactMap(\.?.data).asDriver(onErrorJustReturn: [])
    }
    
    var didFinishLoadingTrailerObservable: Driver<(Bool, Anime)> {
        didFinishLoadingTrailer.skip(1).asDriver(onErrorJustReturn: (false, Anime()))
    }
    
    func findAnime(id: Int, detailSection: DetailFeedSection) {
        repository.getAnime(id: id, detailSection: detailSection)
            .map(\.?.singleData)
            .compactMap { $0 }
            .asObservable()
            .subscribe(onNext: { [weak self] (anime) in
                self?.animeStorage.accept(anime)
            }, onError: { [weak self] _ in
                self?.animeStorage.accept(Anime())
            })
            .disposed(by: disposeBag)
    }

    func updateAnime(with anime: Anime) {
        guard anime.feedSection != .unknown else { return }
        animeStorage.accept(anime)
    }

    func updateCharacters(animeId: Int) {
        // Send empty event for loading
        repository.getAnimeCharacters(animeId: animeId)
            .asObservable()
            .bind(to: charactersStorage)
            .disposed(by: requestDisposeBag)
    }
    
    func updateReviews(animeId: Int) {
        repository.getAnimeReviews(animeId: animeId)
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                self?.reviewsStorage.accept(result)
            }, onError: { [weak self] _ in
                self?.reviewsStorage.accept(JikanResult<ReviewInfo>())
            })
            .disposed(by: disposeBag)
    }
    
    func updateRecommendations(animeId: Int) {
        repository.getAnimeRecommendations(animeId: animeId)
            .asObservable()
            .bind(to: recommendationsStorage)
            .disposed(by: disposeBag)
    }
    
    func cleanRequests() {
       requestDisposeBag = DisposeBag()
    }
}
