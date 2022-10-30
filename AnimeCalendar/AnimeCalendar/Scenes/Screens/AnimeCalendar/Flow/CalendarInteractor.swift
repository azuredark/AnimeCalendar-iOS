//
//  CalendarInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

protocol CalendarInteractive {}

final class CalendarInteractor {
    // MARK: State
    private let requestsManager: RequestProtocol

    // MARK: Initializers
    init(requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }

    // MARK: Methods
}

extension CalendarInteractor: CalendarInteractive {}
