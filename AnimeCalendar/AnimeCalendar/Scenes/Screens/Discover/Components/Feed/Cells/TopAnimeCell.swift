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
    var index: Int?
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

    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alpha = 0.7
        coverImageView.addSubview(view)
        return view
    }()

    private lazy var rankContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.cream.withAlphaComponent(0.6)
        coverImageView.addSubview(container)
        return container
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.white
        label.font = .systemFont(ofSize: 32.0, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
        rankContainer.addSubview(label)
        return label
    }()


    override func prepareForReuse() {
        super.prepareForReuse()
        presenter = nil
        coverImageView.image = nil
        rankLabel.text = nil
    }

    #warning("Rank should be related to the id")
    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
//        rankLabel.text = "\(anime?.rank ?? 0)"
        rankLabel.text = "\(index ?? 0)"
        
//        let imagePath: String = anime?.imageType.jpgImage.normal ?? ""
//        presenter?.getImageResource(path: imagePath, completion: { [weak self] image in
//            DispatchQueue.main.async {
//                self?.coverImageView.image = image
//            }
//        })
    }
}

private extension TopAnimeCell {
    func setupUI() {
        layoutContainer()
        layoutCoverImageView()
        layoutBlurView()
        layoutRankContainer()
        layoutRankLabel()
    }

    func layoutContainer() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        #warning("Is using tooooo much memory, up to 100mb")
//        configureContainerShadow()
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }

    func layoutBlurView() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }

    func layoutRankContainer() {
        NSLayoutConstraint.activate([
            rankContainer.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            rankContainer.widthAnchor.constraint(equalToConstant: 50.0),
            rankContainer.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            rankContainer.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }
    
    func layoutRankLabel() {
        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: rankContainer.leadingAnchor, constant: 3),
            rankLabel.trailingAnchor.constraint(equalTo: rankContainer.trailingAnchor, constant: -3),
            rankLabel.centerXAnchor.constraint(equalTo: rankContainer.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankContainer.centerYAnchor)
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
