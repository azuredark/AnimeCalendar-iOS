//
//  HomeAnimeItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import UIKit

final class HomeAnimeItem: UICollectionViewCell {
  var anime: HomeAnime? {
    didSet {
      print("item anime: \(anime?.name ?? "")")
    }
  }
}
