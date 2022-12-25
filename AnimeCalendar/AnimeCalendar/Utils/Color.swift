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
    static var gray: UIColor { UIColor(named: "App Gray")! }
    static var lightGray: UIColor { UIColor(named: "App Light Gray")! }
    static var black: UIColor { UIColor(named: "App Black")! }
    static var white: UIColor { UIColor(named: "App White")! }
    static var placeholder: UIColor { UIColor(named: "App Placeholder")! }
    static var subtitle: UIColor { UIColor(named: "App Subtitle")! }
}

private extension Color {
    // Not used
    static func hex(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
