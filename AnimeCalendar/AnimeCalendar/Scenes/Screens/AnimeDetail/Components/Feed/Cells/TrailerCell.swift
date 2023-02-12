//
//  TrailerCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

#warning("FIX CELL GOES BLACK DUE TO ANIMATION ON CHARACTER COLLECTION CELL")
final class TrailerCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "DETAIL_FEED_TRAILER_CELL_REUSE_ID"

    var trailer: Trailer?

    /// Will hold the *YTPlayerView*
    weak var trailerComponent: TrailerCompatible?
    weak var ds: DetailFeedDataSource?
    private var playerView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("senku [DEBUG] \(String(describing: type(of: self))) - TRAILER CELL INITIALIZED \(Unmanaged.passUnretained(self).toOpaque())")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: Methods
    func setup() {
        setupUI()
    }
}

private extension TrailerCell {
    /// # For some fking reason `TrailerCell` gets dequed `TWICE (2 INSTANCES)` in `iOS <15.2`.
    /// # UIKit will `instantiate additional` cells to `recalculate sizes`. (Cell registration)
    /// #  In order to prevent it the layout of the component must happen `ONCE` in the `AnimeDetailScreen` lifecycle.
    /// https://developer.apple.com/forums/thread/683775
    func setupUI() {
        guard let ds = ds else { return }
        if !ds.trailerWasPresented {
            layoutPlayerView()
            ds.trailerWasPresented = true
//            setNeedsLayout()
//            layoutIfNeeded()
        }
    }

//    #error("Soooo, on ios 14 TrailerCell gets initialized TWICE for no reason.")
//    #error("Fix wof ...")
//    #error("CHECK FOR TRAILER HASH, IT MAY BE CHANGING")
//    #error("ANIME MAY BE RE-CREATING WITH DIFFERENT HASH")
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
