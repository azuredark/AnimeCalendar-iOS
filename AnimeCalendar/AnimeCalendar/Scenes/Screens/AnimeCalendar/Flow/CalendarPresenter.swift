//
//  CalendarPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol CalendarPresentable: NSObject {
    func start() -> Screen
}

final class CalendarPresenter: NSObject {
    // MARK: State
    private let interactor: CalendarInteractive
    private let router: CalendarRoutable
    weak var view: Screen?

    // MARK: Initializer
    init(interactor: CalendarInteractive, router: CalendarRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension CalendarPresenter: CalendarPresentable {
    func start() -> Screen {
        router.start(presenter: self)
    }
}
