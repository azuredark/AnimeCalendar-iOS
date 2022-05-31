//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

struct SearchAnime {
  var name: String
  var cover: String
  var rating: Float
  var episodesCount: Int
  var year: Int
  var synopsis: String
  var genres: [AnimeGenre]
  var onAir: Bool

  init(name: String, cover: String, rating: Float, episodesCount: Int, year: Int, synopsis: String, genres: [AnimeGenre], onAir: Bool) {
    self.name = name
    self.cover = cover
    self.rating = rating
    self.episodesCount = episodesCount
    self.year = year
    self.synopsis = synopsis
    self.genres = genres
    self.onAir = onAir
  }

  // Default anime
  init() {
    self.init(
      name: "Komi can't communicate",
      cover: "new-anime-item-komicantcommunicate",
      rating: 8.5,
      episodesCount: 12,
      year: 2021,
      synopsis: "Hitohito Tadano is an ordinary boy who heads into his first day of high school with a clear plan: to avoid trouble and do his best to blend in with others. Unfortunately, he fails right away when he takes the seat beside the school's madonna—Shouko Komi. His peers now recognize him as someone to eliminate for a chance to sit next to the most beautiful girl in class",
      genres: [
        AnimeGenre(name: "Comedy"),
        AnimeGenre(name: "Romantic"),
        AnimeGenre(name: "School")
      ],
      onAir: false
    )
  }

  init(name: String, cover: String, onAir: Bool = false) {
    self.init(
      name: name,
      cover: cover,
      rating: 8.5,
      episodesCount: 12,
      year: 2021,
      synopsis: "Hitohito Tadano is an ordinary boy who heads into his first day of high school with a clear plan: to avoid trouble and do his best to blend in with others. Unfortunately, he fails right away when he takes the seat beside the school's madonna—Shouko Komi. His peers now recognize him as someone to eliminate for a chance to sit next to the most beautiful girl in class",
      genres: [
        AnimeGenre(name: "Comedy"),
        AnimeGenre(name: "Romantic"),
        AnimeGenre(name: "School")
      ],
      onAir: onAir
    )
  }
}
