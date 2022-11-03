//
//  NewAnimePresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewAnimePresentable: NSObject {
    func start() -> Screen
    var searchInput: PublishSubject<String> { get }
    var searchAnimeResult: Driver<[JikanAnime]> { get }
}

final class NewAnimePresenter: NSObject {
    // MARK: State
    private let interactor: NewAnimeInteractive
    private let router: NewAnimeRoutable

    // MARK: Initializers
    init(interactor: NewAnimeInteractive, router: NewAnimeRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension NewAnimePresenter: NewAnimePresentable {
    func start() -> Screen {
        router.start(presenter: self)
    }
    
    var searchInput: PublishSubject<String> {
        interactor.searchInput
    }
    
    var searchAnimeResult: Driver<[JikanAnime]> {
        interactor.searchAnimeResult
    }
}
