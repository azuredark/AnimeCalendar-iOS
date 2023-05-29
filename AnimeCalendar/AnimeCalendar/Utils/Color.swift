//
//  Color.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import Foundation
import UIKit

public enum Color {
    static var cream: UIColor { UIColor(named: "App Cream")! }
    static var pink: UIColor { UIColor(named: "App Pink")! }
    static var cobalt: UIColor { UIColor(named: "App Cobalt")! }
    static var gray: UIColor { UIColor.systemGray }
    static var gray5: UIColor { UIColor.systemGray5 }
    static var lightGray: UIColor { UIColor(named: "App Light Gray")! }
    static var black: UIColor { UIColor(named: "App Black")! }
    static var white: UIColor { UIColor(named: "App White")! }
    static var blue: UIColor { UIColor(red: 159, green: 189, blue: 255) ?? UIColor() }
    static var red: UIColor { UIColor(red: 255, green: 160, blue: 161) ?? UIColor() }
    static var placeholder: UIColor { UIColor(named: "App Placeholder")! }
    static var subtitle: UIColor { UIColor(named: "App Subtitle")! }
    
    /// # Static colors
    static var staticBlack: UIColor { .black }
    static var staticWhite: UIColor { .white }
}
