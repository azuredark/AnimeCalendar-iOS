//
//  ACFont.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/11/22.
//

import UIKit

struct ACFont {
    static let bold = FontBold()
}

struct FontBold {
    var medium1: UIFont {
        return .boldSystemFont(ofSize: 24.0)
    }
    
    var sectionTitle2: UIFont {
        return .boldSystemFont(ofSize: 16.0)
    }
}
