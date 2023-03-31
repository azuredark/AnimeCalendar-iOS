//
//  SeasonAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit
import RxSwift
import RxCocoa

final class SeasonAnimeCell: UICollectionViewCell, FeedCell {
    // MARK: Reference object
    var anime: Anime?
    var cellTags: [AnimeCellTag?] = []
    private var overlayApplied: Bool = false
    private let cornerRadius: CGFloat = 5.0

    weak var presenter: DiscoverPresentable?

    // MARK: State
    static var reuseIdentifier: String = "SEASON_ANIME_CELL_RESUSE_ID"

    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.numberOfLines = 3
        label.textColor = Color.staticWhite
        label.textAlignment = .left
        label.alpha = 0

        // Shadow
        label.layer.shadowColor = Color.staticBlack.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        contentView.addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !overlayApplied {
            applyOverlay()
        }
    }

    /// Reset cell's state when preparing for reusing
    override func prepareForReuse() {
        super.prepareForReuse()
        presenter = nil
        coverImageView.image = nil
        titleLabel.text = nil
        titleLabel.alpha = 0

        cellTags.forEach { $0?.removeFromSuperview() }
        cellTags = []
    }

    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
        setupCoverImage()
        setupTitle()
    }

    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension SeasonAnimeCell {
    func setupCoverImage() {
        let path: String? = anime?.imageType?.jpgImage.attemptToGetImageByResolution(.large)
        coverImageView.loadImage(from: path, cellType: self) { [weak self] _ in
            self?.layoutCellTag()

            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                self.titleLabel.alpha = 1
            }
        }
    }

    func setupTitle() {
        titleLabel.text = anime?.titleEng
    }
}

private extension SeasonAnimeCell {
    func layoutUI() {
        contentView.clipsToBounds = true
        contentView.addCornerRadius(radius: 5.0)

        layoutCoverImageView()
        layoutTitleLabel()
    }

    func layoutCoverImageView() {
        coverImageView.fitViewTo(contentView)
    }

    func layoutTitleLabel() {
        let xPadding: CGFloat = 5.0
        let yPadding: CGFloat = 30.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: xPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: coverImageView.trailingAnchor, constant: -xPadding),
            titleLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -yPadding)
        ])
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
        let cellTags = tags.compactMap { [weak self] tag in
            DispatchQueue.global(qos: .userInitiated).sync { [weak self, tag] in
                self?.createTag(tag: tag)
            }
        }

        // Align the AnimeCellTags
        alignTags(cellTags: cellTags)
    }

    /// Creates tags by AnimeTag
    func createTag(tag: AnimeTag) -> AnimeCellTag {
        switch tag {
            case .episodes(let value):
                let icon = ACIcon.tvFilled.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)", iconColor: Color.staticWhite)
                return AnimeCellTag(config: config)
            case .score(let value):
                let icon = ACIcon.starFilled.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)", iconColor: Color.staticWhite)
                return AnimeCellTag(config: config)
            case .rank(let value):
                let icon = ACIcon.trophy.withRenderingMode(.alwaysTemplate)
                let config = AnimeCellTag.Config(iconImage: icon, iconText: "\(value)", iconColor: Color.staticWhite)
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
            strongSelf.contentView.addSubview($0)
        }
        
        let spacingBetweenTags: CGFloat = 10.0

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
                    bottomTag.leadingAnchor.constraint(equalTo: topTag.trailingAnchor, constant: spacingBetweenTags).isActive = true
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
                    middleTag.leadingAnchor.constraint(equalTo: topTag.trailingAnchor, constant: spacingBetweenTags).isActive = true
                }
                alignTag(bottomTag, tagsCount: 3, position: .bottom) { [weak middleTag] bottomTag in
                    guard let middleTag = middleTag else { return }
                    bottomTag.leadingAnchor.constraint(equalTo: middleTag.trailingAnchor, constant: spacingBetweenTags).isActive = true
                }

                self.cellTags.append(contentsOf: [topTag, middleTag, bottomTag])

            default: break
        }

        cellTags.forEach { $0.fadeIn(duration: 0.4) }
    }

    func alignTag(_ tag: AnimeCellTag, tagsCount: Int, position: TagPosition, _ completion: ((AnimeCellTag) -> Void)? = nil) {
        let hasOneTag: Bool   = (tagsCount == 1)
        let hasTwoTag: Bool   = (tagsCount == 2)

        let padding: CGFloat = 5.0

        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [
            tag.heightAnchor.constraint(equalToConstant: 20.0),
            tag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])

        switch position {
            case .top:
                guard !hasOneTag else { return }
                tag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
            case .middle:
                guard !hasTwoTag else { return }
                completion?(tag)
            case .bottom:
                guard !hasOneTag else { return }
                tag.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding).isActive = true
                completion?(tag)
        }

        NSLayoutConstraint.activate(constraints)
    }
}

enum TagPosition {
    case top
    case middle
    case bottom
}

private extension SeasonAnimeCell {
    func applyOverlay() {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.clear.cgColor, Color.staticBlack.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 1)
        gradient.frame = contentView.bounds

        contentView.layer.insertSublayer(gradient, above: coverImageView.layer)
        overlayApplied = true
    }
}
