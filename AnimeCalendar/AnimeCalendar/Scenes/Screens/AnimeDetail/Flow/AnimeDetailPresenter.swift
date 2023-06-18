//
//  AnimeDetailPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxCocoa
import RxSwift

protocol AnimeDetailPresentable: AnyObject {
    var animeFeedSection: FeedSection { get set }
    var playerComponent: TrailerCompatible? { get set }
    var anime: Driver<Anime> { get }
    var characters: Driver<[CharacterInfo]> { get }
    var reviews: Driver<[ReviewInfo]> { get }
    var recommendations: Driver<[RecommendationInfo]> { get }
    var trailerLoaded: PublishRelay<Bool> { get }
    var didFinishLoadingAnimeAndTrailer: Driver<(Bool, Anime)> { get }
    
    /// Weak reference towards the view
    func start(animeIsPreloaded: Bool) -> Screen
    func setCoverImage(with image: UIImage?)
    func setThemeColor(with themeColor: UIColor?)
    
    func findAnime(id: Int, section: DetailFeedSection, configure: ((_ partialAnime: Anime?) -> Void)?)
    func updateAnime(with anime: Anime)
    func updateCharacters(animeId: Int)
    func updateReviews(animeId: Int)
    func updateAnimeRecommendations(animeId: Int)
    
    func disposeTrailerComponent()
    func cleanRequests()
    func handle(action: AnimeDetailAction)
}

protocol AnimeDetailPresentableFromView {
    func getBaseNavigation() -> CustomNavigationController?
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
    
    var animeFeedSection: FeedSection = .unknown
    
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
    
    // MARK: Methods
    /// Ask router to create the main module **Screen**.
    func start(animeIsPreloaded: Bool = true) -> Screen {
        return router.start(presenter: self, animeIsPreloaded: animeIsPreloaded)
    }
    
    func setCoverImage(with image: UIImage?) {
        view?.coverImage = image
    }
    
    func setThemeColor(with themeColor: UIColor?) {
        view?.themeColor = themeColor
    }
    
    func findAnime(id: Int, section: DetailFeedSection, configure: ((_ partialAnime: Anime?) -> Void)? = nil) {
        interactor.findAnime(id: id, detailSection: section, configure: configure)
    }
    
    /// Sends a new **anime** event.
    func updateAnime(with anime: Anime) {
        interactor.updateAnime(with: anime)
    }
    
    func updateCharacters(animeId: Int) {
        interactor.updateCharacters(animeId: animeId)
    }
    
    func updateReviews(animeId: Int) {
        let notAllowedSections: [FeedSection] = [.animeUpcoming, .animePromos]
        
        guard !notAllowedSections.includes([animeFeedSection]) else { return }
        
        interactor.updateReviews(animeId: animeId)
    }
    
    func updateAnimeRecommendations(animeId: Int) {
        let notAllowedSections: [FeedSection] = [.animeUpcoming, .animePromos]
        
        guard !notAllowedSections.includes([animeFeedSection]) else { return }
        
        interactor.updateRecommendations(animeId: animeId)
    }
    
    func disposeTrailerComponent() {
        let component = view?.getDetailFeed().getTrailerComponent()
        component?.disposePlayer()
    }
    
    func cleanRequests() {
        interactor.cleanRequests()
    }
    
    func handle(action: AnimeDetailAction) {
        router.handle(action: action)
    }
}

extension AnimeDetailPresenter: AnimeDetailPresentableFromView {
    func getBaseNavigation() -> CustomNavigationController? {
        return view?.getBaseNavigation()
    }
}
