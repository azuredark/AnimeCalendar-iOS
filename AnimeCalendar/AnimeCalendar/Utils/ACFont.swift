//
//  ACFont.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/11/22.
//

import UIKit

struct ACFont {
    static let bold = FontBold()
    
    // Fonts
    static let medium1: UIFont  = .systemFont(ofSize: 14.0, weight: .medium)
    static let regular1: UIFont = .systemFont(ofSize: 12.0, weight: .regular)
    static let normal: UIFont   = .systemFont(ofSize: 18, weight: .medium)
    static let modalTitle: UIFont = .systemFont(ofSize: 24, weight: .medium)
}

struct FontBold {
    var medium1: UIFont {
        return .boldSystemFont(ofSize: 24.0)
    }
    
    var regular1: UIFont { .systemFont(ofSize: 12, weight: .bold) }
    
    var sectionTitle2: UIFont { .boldSystemFont(ofSize: 16.0) }
    
    var sectionTitle3: UIFont { .boldSystemFont(ofSize: 14.0) }
    
    var modalTitle: UIFont { .systemFont(ofSize: 24, weight: .bold) }
}
