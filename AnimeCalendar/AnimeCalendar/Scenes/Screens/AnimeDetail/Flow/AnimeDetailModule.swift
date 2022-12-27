//
//  AnimeDetailModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

final class AnimeDetailModule: Modulable {
    // MARK: State
    private(set) var presenter: AnimeDetailPresenter
    
    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = AnimeDetailRouter(baseController: navigation)
        let interactor = AnimeDetailInteractor(repository: animeRepository)
        
        self.presenter = AnimeDetailPresenter(router: router, interactor: interactor)
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
        presenter.updateAnime(with: anime)
    }
}
