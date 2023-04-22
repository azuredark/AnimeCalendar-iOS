//
//  PromoAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

final class PromoAnimeCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "PROMO_ANIME_CELL_REUSE_ID"
    private var shadowExists: Bool = false
    private var cornerRadius: CGFloat = 5.0
    private var overlayApplied: Bool = false

    weak var presenter: DiscoverPresentable?
    weak var promo: Promo?

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addCornerRadius(radius: cornerRadius)
        contentView.addSubview(imageView)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        label.textColor = Color.staticWhite
        label.textAlignment = .left
        label.alpha = 0
        
        // Shadow
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
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
    }

    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
        setupCoverImage()
        setupTitleLabel()
    }

    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension PromoAnimeCell {
    func setupCoverImage() {
        let imagePath: String? = promo?.trailer.image.attemptToGetImageByResolution(.large)
        coverImageView.loadImage(from: imagePath, cellType: self) { [weak self] _ in
            guard let self else { return }
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.titleLabel.isHidden = false
                self?.titleLabel.alpha = 1
            }
        }
    }

    func setupTitleLabel() {
        let title = self.promo?.anime.titleEng
        titleLabel.text = title
    }
}

private extension PromoAnimeCell {
    func layoutUI() {
        contentView.addCornerRadius(radius: cornerRadius)
        layoutCoverImageView()
        layoutTitleLabel()
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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

private extension PromoAnimeCell {
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
