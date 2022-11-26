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

    weak var presenter: DiscoverPresentable?
    var promo: Promo? { didSet { setupUI() }}

    private lazy var mainContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.white
        container.addCornerRadius(radius: 10.0)
        contentView.addSubview(container)
        return container
    }()

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        mainContainer.addSubview(imageView)
        return imageView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }

    // MARK: Methods
    func setup() {
        let imagePath: String = promo?.trailer.image.normal ?? ""
        presenter?.getImageResource(path: imagePath, completion: { [weak self] image in
            self?.coverImageView.image = image
        })
    }

    private func setupUI() {
        layoutContainer()
        layoutCoverImageView()
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
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }
}
