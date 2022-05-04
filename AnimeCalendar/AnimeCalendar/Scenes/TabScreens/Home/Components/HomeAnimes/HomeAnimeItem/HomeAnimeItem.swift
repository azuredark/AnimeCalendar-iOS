//
//  HomeAnimeItem.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import UIKit

final class HomeAnimeItem: UICollectionViewCell {
  /// # Outlets
  @IBOutlet private weak var animeCoverPicture: UIImageView!
  @IBOutlet private weak var animeCoverView: UIView!
  @IBOutlet private weak var animeContainerView: UIView!

  var anime: HomeAnime?
  private let cornerRadius: CGFloat = 15
}

extension HomeAnimeItem {
  override func awakeFromNib() {
    super.awakeFromNib()
    print("AWOKE FROM NIB")
    configureCollectionItem()
  }
}

// TODO: Create abstraction for CollectionItem
extension HomeAnimeItem {
  func configureCollectionItem() {
    configurePictureView()
    configurePictureImage()
  }

  func configurePictureView() {
    let animeCoverShadow = Shadow(.bottom)
    animeCoverView.addBottomShadow(shadow: animeCoverShadow, layerRadius: cornerRadius)
  }

  func configurePictureImage() {
    animeCoverPicture.addCornerRadius(radius: cornerRadius)
    animeContainerView.addCornerRadius(radius: cornerRadius)
  }
}
