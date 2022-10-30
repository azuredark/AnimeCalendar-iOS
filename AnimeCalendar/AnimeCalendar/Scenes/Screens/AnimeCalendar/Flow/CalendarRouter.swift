//
//  CalendarRouter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol CalendarRoutable {
    func start(presenter: CalendarPresentable) -> Screen
}

final class CalendarRouter {
    // MARK: State

    // MARK: Initializers
    init() {}

    // MARK: Methods
}

extension CalendarRouter: CalendarRoutable {
    func start(presenter: CalendarPresentable) -> Screen {
        return AnimeCalendarScreen(presenter: presenter)
    }
}
