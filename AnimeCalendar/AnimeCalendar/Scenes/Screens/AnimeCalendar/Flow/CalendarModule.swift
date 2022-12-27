//
//  CalendarModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

final class CalendarModule: Modulable {
    // MARK: State
    private(set) var presenter: CalendarPresenter
    private(set) var baseNavigation: CustomNavigationController

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        let navigation = CustomNavigationController()
        
        let router = CalendarRouter(baseNavigation: navigation)
        let interactor = CalendarInteractor(animeRepository: animeRepository)
        
        self.baseNavigation = navigation
        self.presenter = CalendarPresenter(interactor: interactor, router: router)
    }
    
    /// Initiates and returns the CalendarScreen (UIViewController)
    /// - Returns: Screen
    func start() -> CustomNavigationController {
        let screen = presenter.start()
        baseNavigation.setViewControllers([screen], animated: false)
        
        presenter.view = screen
        return baseNavigation
    }
}
