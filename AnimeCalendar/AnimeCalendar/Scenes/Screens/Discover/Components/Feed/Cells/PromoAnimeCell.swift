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

    weak var presenter: DiscoverPresentable?
    var promo: Promo? { didSet { setupUI() }}

    private lazy var mainContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.white
        contentView.addSubview(container)
        return container
    }()

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addCornerRadius(radius: 10.0)
        mainContainer.addSubview(imageView)
        return imageView
    }()

    private lazy var titleBlurContainerView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.opacity = 0.85
        blurView.clipsToBounds = true
        coverImageView.addSubview(blurView)
        return blurView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        mainContainer.addSubview(label) // Don't add directly to the blur containerview
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }

    // MARK: Methods
    func setup() {
        titleLabel.text = promo?.anime.titleEng
        let imagePath: String = promo?.trailer.image.large ?? ""
        presenter?.getImageResource(path: imagePath, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
        })
    }

    private func setupUI() {
        layoutContainer()
        layoutCoverImageView()
        layoutTitleBlurContainerView()
        layoutTitleLabel()
    }
}

private extension PromoAnimeCell {
    func layoutContainer() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        configureContainerShadow()
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }

    func layoutTitleBlurContainerView() {
        NSLayoutConstraint.activate([
            titleBlurContainerView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            titleBlurContainerView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            titleBlurContainerView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            titleBlurContainerView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    func layoutTitleLabel() {
        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleBlurContainerView.leadingAnchor, constant: xInset),
            titleLabel.trailingAnchor.constraint(equalTo: titleBlurContainerView.trailingAnchor, constant: -xInset),
            titleLabel.centerYAnchor.constraint(equalTo: titleBlurContainerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: titleBlurContainerView.centerXAnchor)
        ])
    }
}

private extension PromoAnimeCell {
    func configureContainerShadow() {
        if !shadowExists {
            mainContainer.setNeedsLayout()
            mainContainer.layoutIfNeeded()
            let shadow = ShadowBuilder().getTemplate(type: .full)
                .with(opacity: 0.25)
                .with(cornerRadius: 10.0)
                .build()
            mainContainer.addShadow(with: shadow)
            shadowExists = true
        }
    }
}
