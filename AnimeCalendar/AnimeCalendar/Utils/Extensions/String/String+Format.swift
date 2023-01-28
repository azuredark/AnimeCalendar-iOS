//
//  String+Format.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/12/22.
//

import Foundation

extension Array where Element == String {
    func formatList(by separator: String, endSeparator: String) -> String {
        var listCopy: [Element] = self.map { $0 }
        let lastElement = listCopy.removeLast()
        var finalText: String = listCopy.joined(separator: "\(separator) ")
        finalText += " \(endSeparator) \(lastElement)"
        
        return finalText
    }
}
