//
//  AnimeDetailRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

protocol AnimeDetailRoutable {
    func start(presenter: AnimeDetailPresentable) -> Screen
}

final class AnimeDetailRouter {
    // MARK: State
    weak var baseNavigation: CustomNavigationController?

    // MARK: Initializers
    init(baseController: CustomNavigationController) {
        self.baseNavigation = baseController
    }

    // MARK: Methods
}

extension AnimeDetailRouter: AnimeDetailRoutable {
    /// Create **AnimeDetailScreen** view controller.
    /// - Parameter presenter: AnimeDetail presenter.
    /// - Returns: Main module screen view.
    func start(presenter: AnimeDetailPresentable) -> Screen {
        return AnimeDetailScreen(presenter: presenter)
    }
}
