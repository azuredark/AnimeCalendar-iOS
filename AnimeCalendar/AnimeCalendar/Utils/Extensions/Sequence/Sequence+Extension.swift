//
//  Sequence+Extension.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/06/23.
//

import Foundation

extension Sequence where Element: Hashable {
    var allItemsAreRepeated: Bool {
        return Set(self).count <= 1
    }
    
    func includes(_ sequence: Array<Element>) -> Bool {
        let lhs = Set(self)
        let rhs = Set(sequence)
        
        return !(rhs.intersection(lhs).isEmpty)
    }
}
