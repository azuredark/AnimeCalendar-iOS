//
//  DiscoverModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

final class DiscoverModule: Modulable {
    // MARK: State
    private(set) var presenter: DiscoverPresenter
    private(set) var baseNavigation: CustomNavigationController
    
    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = DiscoverRouter(baseController: navigation)
        let interactor = DiscoverInteractor(repository: animeRepository)
        
        self.baseNavigation = navigation
        self.presenter = DiscoverPresenter(interactor: interactor, router: router)
    }
    
    // MARK: Methods
    /// Initiates and returns the DiscoverScreen (UIViewController)
    /// - Returns: Screen
    func start() -> CustomNavigationController {
        let screen = presenter.start()
        baseNavigation.setViewControllers([screen], animated: false)
        self.presenter.view = screen
        return baseNavigation
    }
}
