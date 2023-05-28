//
//  DiscoverRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit

protocol DiscoverRoutable {
    /// Creates the DiscoverScreen.
    /// - Parameter presenter: Home's presenter.
    /// - Returns: Screen
    func start(presenter: DiscoverPresentable) -> Screen

    /// Handles **actions** made in the DiscoverScreen.
    /// - Parameter action: Action to execute.
    func handle(action: DiscoverAction)
}

final class DiscoverRouter {
    // MARK: State
    private weak var baseNavigation: UINavigationController?

    // MARK: Initializers
    init(baseController: UINavigationController?) {
        baseController?.modalPresentationStyle = .pageSheet
        self.baseNavigation = baseController
    }
}

extension DiscoverRouter: DiscoverRoutable {
    func start(presenter: DiscoverPresentable) -> Screen {
        return DiscoverScreen(presenter: presenter)
    }

    func handle(action: DiscoverAction) {
        switch action {
            case .transition(let screen):
                handleTransition(to: screen)
        }
    }
}

// MARK: - Transitions
private extension DiscoverRouter {
    func handleTransition(to screen: ScreenType) {
        switch screen {
            case .animeDetailScreen(let anime):
                openDetailScreen(with: anime)
            default: break
        }
    }

    func openDetailScreen(with anime: Anime?) {
        guard let anime = anime else { return }
        let module = AnimeCalendarModule.shared.getAnimeDetailModule()
        let controller = module.start()
        controller.modalPresentationStyle = .formSheet
        module.build(with: anime)

        baseNavigation?.present(controller, animated: true)
    }
}

/// Actions to execute in **Discover**
enum DiscoverAction {
    case transition(to: ScreenType)
}
