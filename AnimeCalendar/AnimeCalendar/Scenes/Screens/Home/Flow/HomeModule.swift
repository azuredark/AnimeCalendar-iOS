//
//  HomeModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/10/22.
//

final class HomeModule: Modulable {
    // MARK: State
    private(set) var presenter: HomePresenter
    private(set) var baseNavigation: CustomNavigationController
    
    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = HomeRouter(baseNavigation: navigation)
        let interactor = HomeInteractor(animeRepository: animeRepository)
        
        self.baseNavigation = navigation
        self.presenter = HomePresenter(interactor: interactor, router: router)
    }
    
    /// Initiates and returns the HomeScreen (UIViewController)
    /// - Returns: Screen
    func start() -> CustomNavigationController {
        let screen = presenter.start()
        baseNavigation.setViewControllers([screen], animated: false)
        
        presenter.view = screen
        return baseNavigation
    }
}
