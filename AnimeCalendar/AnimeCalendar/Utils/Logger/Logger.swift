//
//  Logger.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 17/03/23.
//

import Foundation

enum LogEvent {
    case network
    case mock
    case local
    case ui
    case info

    var emoji: String {
        switch self {
            case .network: return "📡"
            case .mock: return "🧪"
            case .local: return "📱"
            case .ui: return "🏠"
            case .info: return "🗞️"
        }
    }
}

enum LogResult {
    case success
    case error
    case other

    var emoji: String {
        switch self {
            case .success: return " -> ✅"
            case .error: return " -> ❌"
            case .other: return ""
        }
    }
}

final class Logger {
    // MARK: State

    // MARK: Initializers
    private init() {}

    // MARK: Methods
    static func log(_ event: LogEvent = .info, _ result: LogResult = .other, msg: String) {
        let emojiEventStr: String = Self.getLogEmoji(event)
        let emojiResultStr: String = Self.getLogEmoji(result)

        print("Logger - [\(emojiEventStr)\(emojiResultStr)] | \(msg)")
    }
}

// MARK: - Private implementations
private extension Logger {
    static func getLogEmoji(_ event: LogEvent) -> String {
        let emojiStr: String = "\(event.emoji)"
        return emojiStr
    }

    static func getLogEmoji(_ result: LogResult) -> String {
        let emojiStr: String = "\(result.emoji)"
        return emojiStr
    }
}
