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
    var cellTags: [AnimeCellTag?] = []

    weak var presenter: DiscoverPresentable?

    // MARK: State
    static var reuseIdentifier: String = "SEASON_ANIME_CELL_RESUSE_ID"

    /// Reset cell's state when preparing for reusing
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        coverImageView.image = nil
        cellTags.forEach { $0?.removeFromSuperview() }
        cellTags = []
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
        layoutCellTag()
    }
}

private extension SeasonAnimeCell {
    func layoutCellTag() {
        // List of, sorted by priority, AnimeTags
        guard let tags = presenter?.getTags(episodes: anime?.episodesCount,
                                            score: anime?.score,
                                            rank: anime?.rank) else { return }
        setupTags(tags: tags)
    }

    /// Set the amount of tags, and their position in the UI respectively
    func setupTags(tags: [AnimeTag]) {
        guard !tags.isEmpty else { return }

        // Create AnimeCellTags from each AnimeTag
        let cellTags = tags.compactMap { [weak self] in
            self?.createTag(tag: $0)
        }

        // Align the AnimeCellTags
        alignTags(cellTags: cellTags)
    }

    /// Creates tags by AnimeTag
    func createTag(tag: AnimeTag) -> AnimeCellTag {
        switch tag {
            case .episodes(let value):
                let icon = UIImage(systemName: "tv.fill")!.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)")
                return AnimeCellTag(config: config)
            case .score(let value):
                let icon = UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)")
                return AnimeCellTag(config: config)
            case .rank(let value):
                let icon = ACIcon.trophy.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)")
                return AnimeCellTag(config: config)
        }
    }

    /// Align all available AnimeCellTags, according to the amount of them.
    /// - Parameter cellTags: Array if AnimeCellTag.
    func alignTags(cellTags: [AnimeCellTag]) {
        // Setting up common properties
        cellTags.forEach { [weak self] in
            guard let strongSelf = self else { return }
            $0.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.mainContainer.addSubview($0)
        }

        switch cellTags.count {
            case 1:
                let middleTag = cellTags[0]

                // Align 1 tag
                alignTag(middleTag, tagsCount: 1, position: .middle)

                self.cellTags.append(contentsOf: [middleTag])
            case 2:
                let topTag = cellTags[0]
                let bottomTag = cellTags[1]

                // Align 2 tags
                alignTag(topTag, tagsCount: 2, position: .top)
                alignTag(bottomTag, tagsCount: 2, position: .bottom) { [weak topTag] bottomTag in
                    guard let topTag = topTag else { return }
                    bottomTag.topAnchor.constraint(equalTo: topTag.bottomAnchor, constant: 20.0).isActive = true
                }

                self.cellTags.append(contentsOf: [topTag, bottomTag])
            case 3:
                let topTag = cellTags[0]
                let middleTag = cellTags[1]
                let bottomTag = cellTags[2]

                // Align 3 tags
                alignTag(topTag, tagsCount: 3, position: .top)
                alignTag(middleTag, tagsCount: 3, position: .middle) { [weak topTag] middleTag in
                    guard let topTag = topTag else { return }
                    middleTag.topAnchor.constraint(equalTo: topTag.bottomAnchor, constant: 20.0).isActive = true
                }
                alignTag(bottomTag, tagsCount: 3, position: .bottom) { [weak middleTag] bottomTag in
                    guard let middleTag = middleTag else { return }
                    bottomTag.topAnchor.constraint(equalTo: middleTag.bottomAnchor, constant: 20.0).isActive = true
                }

                self.cellTags.append(contentsOf: [topTag, middleTag, bottomTag])

            default: break
        }
    }

    func alignTag(_ tag: AnimeCellTag, tagsCount: Int, position: TagPosition, _ completion: ((AnimeCellTag) -> Void)? = nil) {
        let hasOneTag: Bool = (tagsCount == 1)
        let hasTwoTag: Bool = (tagsCount == 2)
        let hasThreeTag: Bool = (tagsCount == 3)

        switch position {
            case .top:
                guard !hasOneTag else { return }
                let yInset: CGFloat = hasTwoTag ? -60 : (hasThreeTag ? -80 : 0)

                NSLayoutConstraint.activate([
                    tag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    tag.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: yInset),
                    tag.heightAnchor.constraint(equalToConstant: 20.0),
                    tag.widthAnchor.constraint(equalToConstant: 55.0)
                ])

            case .middle:
                guard !hasTwoTag else { return }

                NSLayoutConstraint.activate([
                    tag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    tag.heightAnchor.constraint(equalToConstant: 20.0),
                    tag.widthAnchor.constraint(equalToConstant: 55.0)
                ])

                tag.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: -55.0).isActive = hasOneTag
                completion?(tag)

            case .bottom:
                guard !hasOneTag else { return }

                NSLayoutConstraint.activate([
                    tag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    tag.heightAnchor.constraint(equalToConstant: 20.0),
                    tag.widthAnchor.constraint(equalToConstant: 55.0)
                ])
                completion?(tag)
        }
    }
}

enum TagPosition {
    case top
    case middle
    case bottom
}
