//
//  AnimeDetailPresenter.swift //  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxCocoa
import RxSwift

protocol AnimeDetailPresentable: AnyObject {
    var playerComponent: TrailerCompatible? { get set }
    var anime: Driver<Anime> { get }
    var characters: Driver<[CharacterInfo]> { get }
    var reviews: Driver<[ReviewInfo]> { get }
    var recommendations: Driver<[RecommendationInfo]> { get }
    var trailerLoaded: PublishRelay<Bool> { get }
    var didFinishLoadingAnimeAndTrailer: Driver<(Bool, Anime)> { get }

    /// Weak reference towards the view
    func start() -> Screen
    func setCoverImage(with image: UIImage?)
    
    func updateAnime(with anime: Anime)
    func updateCharacters(animeId: Int)
    func updateReviews(animeId: Int)
    func updateAnimeRecommendations(animeId: Int)
        
    func disposeTrailerComponent()
    func cleanRequests()
}

final class AnimeDetailPresenter: AnimeDetailPresentable {
    // MARK: State
    private var router: AnimeDetailRoutable
    private var interactor: AnimeDetailInteractive
    
    weak var view: AnimeDetailScreen?
    weak var playerComponent: TrailerCompatible?

    private let disposeBag = DisposeBag()

    // MARK: Initializers
    init(router: AnimeDetailRoutable, interactor: AnimeDetailInteractive) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: Methods
    /// Tracks when a new **anime** event is fired.
    var anime: Driver<Anime> {
        interactor.animeObservable
    }

    /// Anime characters (Main & secondary)
    var characters: Driver<[CharacterInfo]> {
        interactor.animeCharactersObservable
    }
    
    var reviews: Driver<[ReviewInfo]> {
        interactor.animeReviewsObservable
    }
    
    var recommendations: Driver<[RecommendationInfo]> {
        interactor.animeRecommendationsObservable
    }

    /// Tracks when the **trailer** has loaded and will be displayed.
    var trailerLoaded: PublishRelay<Bool> {
        interactor.animeTrailerLoadedObservable
    }

    /// Tracks when both the **anime** & **trailer** have finished loading and emits an event.
    /// This event fires up a new section being added into the **mainCollection**
    var didFinishLoadingAnimeAndTrailer: Driver<(Bool, Anime)> {
        interactor.didFinishLoadingTrailerObservable
    }

    /// Ask router to create the main module **Screen**.
    func start() -> Screen {
        return router.start(presenter: self)
    }
    
    func setCoverImage(with image: UIImage?) {
        view?.coverImage = image
    }

    /// Sends a new **anime** event.
    func updateAnime(with anime: Anime) {
        interactor.updateAnime(with: anime)
    }

    func updateCharacters(animeId: Int) {
        interactor.updateCharacters(animeId: animeId)
    }
    
    func updateReviews(animeId: Int) {
        interactor.updateReviews(animeId: animeId)
    }
    
    func updateAnimeRecommendations(animeId: Int) {
        interactor.updateRecommendations(animeId: animeId)
    }

    func disposeTrailerComponent() {
        let component = view?.getDetailFeed().getTrailerComponent()
        component?.disposePlayer()
    }
    
    func cleanRequests() {
        interactor.cleanRequests()
    }
}
