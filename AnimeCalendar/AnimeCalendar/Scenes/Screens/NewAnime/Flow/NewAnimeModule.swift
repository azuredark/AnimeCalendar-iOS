//
//  NewAnimeModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

final class NewAnimeModule: Modulable {
    // MARK: State
    private(set) var presenter: NewAnimePresenter
    private(set) var baseNavigation: CustomNavigationController

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = NewAnimeRouter(baseNavigation: navigation)
        let interactor = NewAnimeInteractor(repository: animeRepository)
        
        self.baseNavigation = navigation
        self.presenter = NewAnimePresenter(interactor: interactor, router: router)
    }
    
    func start() -> CustomNavigationController {
        let screen = presenter.start()
        baseNavigation.setViewControllers([screen], animated: false)
        
        presenter.view = screen as? NewAnimeScreen
        return baseNavigation
    }
}
