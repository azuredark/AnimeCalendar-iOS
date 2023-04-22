//
//  UpcomingAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/03/23.
//

import UIKit

final class UpcomingAnimeCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "UPCOMING_ANIME_CELL_REUSE_ID"
   
    weak var anime: Anime?
    
    private let radius: CGFloat = 5.0
    private var overlayApplied: Bool = false

    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addCornerRadius(radius: radius)
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
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

    // MARK: Initializers
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = nil
        titleLabel.alpha = 0
    }

    // MARK: Methods
    func setup() {
        setupCoverImageView()
        setupTitleLabel()
    }
    
    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension UpcomingAnimeCell {
    func setupCoverImageView() {
        let path: String? = anime?.imageType?.jpgImage.attemptToGetImageByResolution(.large)
        coverImageView.loadImage(from: path, cellType: self) { [weak self] _ in
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                self.titleLabel.alpha = 1
            }
        }
    }
    
    func setupTitleLabel() {
        titleLabel.text = anime?.titleEng
    }
}

private extension UpcomingAnimeCell {
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
        let padding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: coverImageView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -padding)
        ])
    }
}
private extension UpcomingAnimeCell {
    func applyOverlay() {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.clear.cgColor, Color.staticBlack.withAlphaComponent(0.5).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 1) // you need to play with 0.15 to adjust gradient vertically
        gradient.frame = contentView.bounds

        contentView.layer.insertSublayer(gradient, above: coverImageView.layer)
        overlayApplied = true
    }
}
