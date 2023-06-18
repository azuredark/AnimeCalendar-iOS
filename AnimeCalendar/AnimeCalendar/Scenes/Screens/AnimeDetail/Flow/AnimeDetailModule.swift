//
//  AnimeDetailModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

final class AnimeDetailModule: Modulable {
    // MARK: State
    private(set) var presenter: AnimeDetailPresenter
    
    private lazy var playerComponent: TrailerCompatible = {
        let player = TrailerComponent.shared
        player.presenter = presenter
        return player
    }()

    // MARK: Initializers
    init(animeRepository: AnimeRepository, requiresNavigation: Bool) {
        let router = AnimeDetailRouter()
        let interactor = AnimeDetailInteractor(repository: animeRepository)
        
        self.presenter = AnimeDetailPresenter(router: router, interactor: interactor)
        self.presenter.playerComponent = playerComponent
        router.presenter = presenter
    }
    
    // MARK: Methods
    func start() -> CustomNavigationController {
        let baseNavigation = CustomNavigationController()
        let screen = presenter.start()
        
        baseNavigation.setViewControllers([screen], animated: false)
        
        presenter.view = screen as? AnimeDetailScreen
        return baseNavigation
    }
    
    func startViewControllerOnly() -> Screen {
        let screen = presenter.start(animeIsPreloaded: false)
        presenter.view = screen as? AnimeDetailScreen
        
        return screen
    }
    
    /// Builds with anime by **emiting** event.
    func build(with anime: Anime) {
        anime.detailFeedSection = .animeBasicInfo
        anime.trailer?.detailFeedSection = .animeTrailer
        presenter.animeFeedSection = anime.feedSection
        presenter.setCoverImage(with: anime.imageType?.coverImage)
        presenter.updateAnime(with: anime)
    }
    
    /// Build without all the Anime info & requesting it.
    func build(recommendedAnime: Anime, detailFeedSection: DetailFeedSection) {
        guard let malId = recommendedAnime.malId else { return }
        
        presenter.findAnime(id: malId, section: detailFeedSection) { fullAnime in
            fullAnime?.imageType?.themeColor = recommendedAnime.imageType?.themeColor
        }
        
        presenter.animeFeedSection = recommendedAnime.feedSection
        presenter.setCoverImage(with: recommendedAnime.imageType?.coverImage)
    }
}
