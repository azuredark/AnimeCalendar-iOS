//
//  AnimeDetailModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

final class AnimeDetailModule: Modulable {
    // MARK: State
    private(set) var presenter: AnimeDetailPresenter
//    private(set) var baseNavigation: CustomNavigationController
    
    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = AnimeDetailRouter(baseController: navigation)
        let interactor = AnimeDetailInteractor(repository: animeRepository)
        
//        self.baseNavigation = navigation
        self.presenter = AnimeDetailPresenter(router: router, interactor: interactor)
    }
    
    // MARK: Methods
    func start() -> CustomNavigationController {
        let baseNavigation = CustomNavigationController()
        let screen = presenter.start()
        
        baseNavigation.setViewControllers([screen], animated: false)
        
        self.presenter.view = screen
        return baseNavigation
    }
}
