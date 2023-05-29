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
    static let medium1: UIFont = .systemFont(ofSize: 14.0, weight: .medium)
    static let regular1: UIFont = .systemFont(ofSize: 12.0, weight: .regular)
}

struct FontBold {
    var medium1: UIFont {
        return .boldSystemFont(ofSize: 24.0)
    }
    
    var regular1: UIFont {
        return .systemFont(ofSize: 12, weight: .bold)
    }
    
    var sectionTitle2: UIFont {
        return .boldSystemFont(ofSize: 16.0)
    }
    
    var sectionTitle3: UIFont {
        return .boldSystemFont(ofSize: 14.0)
    }
}
