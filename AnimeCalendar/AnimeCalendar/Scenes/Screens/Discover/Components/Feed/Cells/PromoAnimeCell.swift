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

    private(set) lazy var blurView: BlurContainer = {
        let config = BlurContainer.Config(opacity: 1)
        let view = BlurContainer(config: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(view)
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            Color.cobalt,
            Color.black
        ]
        gradient.locations = [0, 1]
        return gradient
    }()
    
    private lazy var gradientView: UIView = {
        let gradient = GradientView(colors: [.clear, .black])
        gradient.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(gradient)
        return gradient
    }()

    /// Reset cell's state when preparing for reusing
    override func prepareForReuse() {
        super.prepareForReuse()
        blurView.reset()
        presenter = nil
        coverImageView.image = nil
    }

    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
        blurView.configure(with: promo?.anime.titleEng ?? "", lines:  1)

        let imagePath: String = promo?.trailer.image.large ?? ""
        presenter?.getImageResource(path: imagePath, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
        })
    }
}

private extension PromoAnimeCell {
    func setupUI() {
        layoutContainer()
        layoutCoverImageView()
        layoutBlurView()
//        layoutGradientLayer()
    }

    func layoutContainer() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        #warning("Is using tooooo much memory, up to 100mb")
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

    func layoutBlurView() {
        let height: CGFloat = 40.0
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            blurView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func layoutGradientLayer() {
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
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
