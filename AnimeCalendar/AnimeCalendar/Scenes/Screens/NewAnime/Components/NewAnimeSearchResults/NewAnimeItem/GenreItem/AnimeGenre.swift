//
//  AnimeGenre.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

struct AnimeGenre: Decodable {
  var name: String

  init(name: String) {
    self.name = name
  }
}
