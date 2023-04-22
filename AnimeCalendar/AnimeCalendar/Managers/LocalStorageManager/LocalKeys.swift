//
//  LocalKeys.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 3/04/23.
//

import Foundation

struct LocalKeys {
    private static var app: String { "AnimeCalendar." }
}

// MARK: - Timers
extension LocalKeys {
    var timeUserLoggedOutSeconds: String { Self.app+"time_user_logged_out_seconds" }
}
