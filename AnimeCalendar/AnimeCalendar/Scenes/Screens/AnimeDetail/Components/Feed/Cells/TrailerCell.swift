//
//  TrailerCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

final class TrailerCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "DETAIL_FEED_TRAILER_CELL_REUSE_ID"

    var trailer: Trailer? { didSet { setupUI() } }

    /// Will hold the *YTPlayerView*
    weak var trailerComponent: TrailerCompatible?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: Methods
    func setup() {
        // Play video ...
//        trailerComponent?.loadTrailer(withId: trailer?.youtubeId ?? "")
    }
}

private extension TrailerCell {
    func setupUI() {
        layoutPlayerView()
    }

    func layoutPlayerView() {
        guard let playerView = trailerComponent?.getContainer() else  { return }
        contentView.addSubview(playerView)

        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
