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
        let player = TrailerComponent()
        player.presenter = presenter
        return player
    }()

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = AnimeDetailRouter(baseController: navigation)
        let interactor = AnimeDetailInteractor(repository: animeRepository)
        
        self.presenter = AnimeDetailPresenter(router: router, interactor: interactor)
        self.presenter.playerComponent = playerComponent
    }
    
    // MARK: Methods
    func start() -> CustomNavigationController {
        let baseNavigation = CustomNavigationController()
        let screen = presenter.start()
        
        baseNavigation.setViewControllers([screen], animated: false)
        
        presenter.view = screen as? AnimeDetailScreen
        return baseNavigation
    }
    
    /// Builds with anime by **emiting** event.
    func build(with anime: Anime) {
        presenter.setCoverImage(with: anime.imageType.coverImage)
        presenter.updateAnime(with: anime)
    }
}
