//
//  RootControllerType.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import Foundation

enum RootControllerType {
    case rootTabBar(screens: [ScreenType], middleButton: Bool = false)
    case rootScreen(screen: ScreenType)
}
