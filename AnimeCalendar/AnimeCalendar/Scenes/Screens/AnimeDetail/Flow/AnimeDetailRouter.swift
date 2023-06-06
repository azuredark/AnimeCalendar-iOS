//
//  AnimeDetailRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

protocol AnimeDetailRoutable {
    func start(presenter: AnimeDetailPresentable) -> Screen
    func handle(action: AnimeDetailAction)
}

final class AnimeDetailRouter {
    // MARK: State
    weak var presenter: (AnimeDetailPresentable & AnimeDetailPresentableFromView)?
    
    // MARK: Initializers
    init() {}

    // MARK: Methods
}

extension AnimeDetailRouter: AnimeDetailRoutable {
    /// Create **AnimeDetailScreen** view controller.
    /// - Parameter presenter: AnimeDetail presenter.
    /// - Returns: Main module screen view.
    func start(presenter: AnimeDetailPresentable) -> Screen {
        return AnimeDetailScreen(presenter: presenter)
    }

    func handle(action: AnimeDetailAction) {
        switch action {
            case .transition(let flow):
                handleTransition(to: flow)
        }
    }
}

private extension AnimeDetailRouter {
    func handleTransition(to screen: DetailFlow) {
        switch screen {
            case .anime(let anime):
                openDetailScreen(with: anime)
            default: break
        }
    }

    func openDetailScreen(with anime: Anime?) {
        guard let anime = anime else { return }
        let module = AnimeCalendarModule.shared.getAnimeDetailModule()
        let controller = module.startViewControllerOnly()
        module.build(with: anime)

        let navigation = presenter?.getBaseNavigation()
        navigation?.pushViewController(controller, animated: true)
    }
}

/// Actions to execute in **AnimeDetail**
enum AnimeDetailAction {
    case transition(to: DetailFlow)
}

enum DetailFlow {
    case review
    case character
    case anime(_: Anime?)
}
