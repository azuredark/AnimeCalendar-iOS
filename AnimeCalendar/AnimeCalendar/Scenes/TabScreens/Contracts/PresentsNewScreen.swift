//
//  PresentsNewScheduledAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 8/05/22.
//

import Foundation
import UIKit

protocol PresentsNewScreen: ScreenProtocol {
  func presentNewScheduledAnime(screen: NewScheduledAnimeScreen)
}

extension PresentsNewScreen {
  func presentNewScheduledAnime(screen: NewScheduledAnimeScreen) {
    print("VC \(self) presenting: \(screen)")
    self.present(screen, animated: true)
  }
}
