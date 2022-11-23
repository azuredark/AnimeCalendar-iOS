//
//  SeasonAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

final class SeasonAnimeCell: GenericFeedCell, FeedCell {
    typealias T = Anime

    // MARK: State
    static var reuseIdentifier: String = "SEASON_ANIME_CELL_RESUSE_ID"

    // MARK: Methods
    func setup(item: Anime) {
        setupUI()
        titleLabel.text = item.title
    }
}
