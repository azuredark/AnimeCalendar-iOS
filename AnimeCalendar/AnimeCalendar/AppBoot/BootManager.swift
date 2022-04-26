//
//  BootManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class BootManager {
  func getBootMethod(_ bootType: BootType) -> Boot {
    switch bootType {
      case .develop:
        return DevelopBoot()
      case .production:
        return ProductionBoot()
    }
  }
}
