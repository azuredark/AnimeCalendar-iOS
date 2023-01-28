//
//  ACStackIdentifiers.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/01/23.
//

import Foundation

enum ACStackIdentifiers {
    private static var id: String { "ac-stack." }
    
    static var stack: String { "\(id)stack" }
    static var imageView: String { "\(id)image-view" }
    static var text: String { "\(id)text" }
    static var spacer: String { "\(id)spacer" }
    static var customView: String { "\(id)custom-view" }
}
