//
//  ACUtils+NewAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 6/07/22.
//

import Foundation

extension ScreenComponent {
  func downCastComponent<T>(to: T) -> T? {
    guard let a = self as? T else { return nil }
    return a
  }
}
