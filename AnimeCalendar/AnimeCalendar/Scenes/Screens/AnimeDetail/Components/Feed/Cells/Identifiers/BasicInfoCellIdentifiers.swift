//
//  BasicInfoCellIdentifiers.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/01/23.
//

import Foundation

enum BasicInfoCellIdentifiers {
    private static let id: String = "basic_info_cell."
    /// # BasicInfoCell
    static var mainStack: String { "\(id)main_stack" }
    static var innerStack: String { "\(id)inner_stack" }
    static var producersStack: String { "\(id)producers_stack" }
    
    /// # BasicInfoHeader
    static var title: String { "\(id)title" }
    static var stack: String { "\(id)stack" }
    
}
