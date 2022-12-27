//
//  HomePresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/10/22.
//

import Foundation
import RxCocoa

protocol HomePresentable: NSObject {
    func start() -> Screen
    func updateUserAnimes(name: String)
    var animes: Driver<[Anime]> { get }
}

final class HomePresenter: NSObject {
    // MARK: State
    private let interactor: HomeInteractive
    private let router: HomeRoutable
    weak var view: Screen?

    // MARK: Initializer
    init(interactor: HomeInteractive, router: HomeRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresentable {
    func start() -> Screen {
        router.start(presenter: self)
    }

    func updateUserAnimes(name: String) {
        interactor.updateUserAnimes(name: name)
    }

    var animes: Driver<[Anime]> {
        return interactor.animes
    }
}
