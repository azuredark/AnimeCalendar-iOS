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
        guard let tags = presenter?.getTags(episodes: anime?.episodesCount,
                                            score: anime?.score,
                                            rank: anime?.rank) else { return }
        setupTags(tags: tags)
    }

    /// Set the amount of tags, and their position in the UI respectively
    func setupTags(tags: [AnimeTag]) {
        guard !tags.isEmpty else { return }

        let cellTags = tags.compactMap { [weak self] in
            self?.createTag(tag: $0)
        }

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

    // TODO: - Refactor!!
    func alignTags(cellTags: [AnimeCellTag]) {
        // Setting up common properties
        cellTags.forEach { [weak self] in
            guard let strongSelf = self else { return }
            $0.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.mainContainer.addSubview($0)
        }

        switch cellTags.count {
            case 1:
                // Align 1 tag
                guard let tag = cellTags.first else { return }
                NSLayoutConstraint.activate([
                    tag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    tag.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: -50.0),
                    tag.heightAnchor.constraint(equalToConstant: 20.0),
                    tag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                self.cellTags.append(contentsOf: [tag])
            case 2:
                // Align 2 tags
                let topTag: AnimeCellTag = cellTags[0]
                let bottomTag: AnimeCellTag = cellTags[1]

                NSLayoutConstraint.activate([
                    topTag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    topTag.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: -60.0),
                    topTag.heightAnchor.constraint(equalToConstant: 20.0),
                    topTag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                NSLayoutConstraint.activate([
                    bottomTag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    bottomTag.topAnchor.constraint(equalTo: topTag.bottomAnchor, constant: 20.0),
                    bottomTag.heightAnchor.constraint(equalToConstant: 20.0),
                    bottomTag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                self.cellTags.append(contentsOf: [topTag, bottomTag])
            case 3:
                // Align 3 tags
                let topTag = cellTags[0]
                let middleTag = cellTags[1]
                let bottomTag = cellTags[2]

                NSLayoutConstraint.activate([
                    topTag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    topTag.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: -80.0),
                    topTag.heightAnchor.constraint(equalToConstant: 20.0),
                    topTag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                NSLayoutConstraint.activate([
                    middleTag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    middleTag.topAnchor.constraint(equalTo: topTag.bottomAnchor, constant: 20.0),
                    middleTag.heightAnchor.constraint(equalToConstant: 20.0),
                    middleTag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                NSLayoutConstraint.activate([
                    bottomTag.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
                    bottomTag.topAnchor.constraint(equalTo: middleTag.bottomAnchor, constant: 20.0),
                    bottomTag.heightAnchor.constraint(equalToConstant: 20.0),
                    bottomTag.widthAnchor.constraint(equalToConstant: 50.0),
                ])

                self.cellTags.append(contentsOf: [topTag, middleTag, bottomTag])

            default: break
        }
    }
}
