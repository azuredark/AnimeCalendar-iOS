//
//  SeasonAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

final class SeasonAnimeCell: GenericFeedCell, FeedCell {
    // MARK: Reference object
    var anime: Anime? { didSet { setupUI(); setNeedsLayout() } }

    // MARK: State
    static var reuseIdentifier: String = "SEASON_ANIME_CELL_RESUSE_ID"
    
    /// Reset cell's state when preparing for reusing
    override func prepareForReuse() {
        titleLabel.text = nil
    }

    // MARK: Methods
    func setup() {
        titleLabel.text = anime?.title
    }
}
