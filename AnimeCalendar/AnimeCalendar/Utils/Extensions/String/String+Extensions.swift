//
//  String+Extensions.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 12/06/23.
//

import Foundation

// MARK: - StringProtocol
extension StringProtocol {
    var isNotEmpty: Bool { !self.isEmpty }
}

// MARK: - Optional: String
extension Optional where Wrapped == String {
    var isNotNilOrEmpty: Bool {
        guard let self else { return false }
        return self.isNotEmpty
    }
}

// MARK: - Optional: AnyObject
extension Optional where Wrapped: AnyObject {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { !self.isNil }
}
