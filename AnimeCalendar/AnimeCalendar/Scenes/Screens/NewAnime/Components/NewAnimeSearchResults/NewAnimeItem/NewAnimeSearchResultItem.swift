//
//  NewAnimeSearchResultItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/22.
//

import UIKit

final class NewAnimeSearchResultItem: UICollectionViewCell {
  /// # Outlets
  @IBOutlet private weak var animeContainerView: UIView!
  /// # Properties
  var anime: HomeAnime? {
    didSet {
      print("SET NewAnimeSearchResultItem")
    }
  }
}

extension NewAnimeSearchResultItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    configureView()
  }
}

private extension NewAnimeSearchResultItem {
  func configureView() {
    contentView.backgroundColor = Color.white
    animeContainerView.backgroundColor = Color.white
    let shadow = Shadow(.bottom)
    animeContainerView.addShadowLayer(shadow: shadow, layerRadius: 15)
  }
}
