//
//  HomeModule.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/10/22.
//

import Foundation

final class HomeModule {
    // MARK: State
    private let presenter: HomePresentable
    
    // MARK: Initializers
    init(requestsManager: RequestProtocol) {
        let interactor = HomeInteractor(requestManager: requestsManager)
        let router = HomeRouter()
        self.presenter = HomePresenter(interactor: interactor, router: router)
    }
}

extension HomeModule {
    /// Initiates and returns the HomeScreen (UIViewController)
    /// - Returns: Screen
    func start() -> Screen {
        presenter.start()
    }
}
