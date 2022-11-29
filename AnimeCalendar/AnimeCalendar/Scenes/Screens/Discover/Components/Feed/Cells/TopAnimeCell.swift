//
//  TopAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/11/22.
//

import UIKit

final class TopAnimeCell: UICollectionViewCell, FeedCell {
    static var reuseIdentifier: String = "TOP_ANIME_CELL_REUSE_ID"
    private var shadowExists: Bool = false

    // MARK: State
    var anime: Anime? { didSet { setupUI() } }
    weak var presenter: DiscoverPresentable?

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

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }

    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
        let imagePath: String = anime?.imageType.jpgImage.normal ?? ""
        presenter?.getImageResource(path: imagePath, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
        })
    }
}

private extension TopAnimeCell {
    func setupUI() {
        layoutContainer()
        layoutCoverImageView()
    }

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
}

private extension TopAnimeCell {
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
