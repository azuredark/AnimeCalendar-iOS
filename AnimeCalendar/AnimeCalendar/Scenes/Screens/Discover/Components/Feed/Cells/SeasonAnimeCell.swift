//
//  SeasonAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

final class SeasonAnimeCell: GenericFeedCell, FeedCell {
    // MARK: Reference object
    var anime: Anime? { didSet { setupUI() } }
    weak var presenter: DiscoverPresentable?

    // MARK: State
    static var reuseIdentifier: String = "SEASON_ANIME_CELL_RESUSE_ID"

    /// Reset cell's state when preparing for reusing
    override func prepareForReuse() {
        titleLabel.text = nil
        coverImageView.image = nil
    }

    // MARK: Methods
    func setup() {
        titleLabel.text = anime?.titleEng
        let imagePath = anime?.imageType.jpgImage.normal ?? ""
        presenter?.getImageResource(path: imagePath) { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
        }
    }
}
