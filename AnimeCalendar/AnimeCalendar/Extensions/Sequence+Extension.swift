//
//  Sequence+Extension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/01/23.
//

import Foundation

extension Sequence where Element: Hashable {
    var allItemsAreRepeated: Bool {
        return Set(self).count <= 1
    }
}
