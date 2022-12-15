//
//  GenericFeedCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedCell {
    static var reuseIdentifier: String { get set }
    func setup()
}

class GenericFeedCell: UICollectionViewCell {
    // MARK: Accessibility id
    private let accessId = GenericFeedCellIdentifiers()

    // MARK: State
    private var shadowExists: Bool = false

    private(set) lazy var mainContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.white
        container.accessibilityIdentifier = accessId.containerId
        contentView.addSubview(container)
        return container
    }()

    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addCornerRadius(radius: 10.0)
        mainContainer.addSubview(view)
        return view
    }()

    private(set) lazy var blurView: BlurContainer = {
        let config = BlurContainer.Config(opacity: 1)
        let view = BlurContainer(config: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(view)
        return view
    }()
    
    private lazy var gradientView: UIView = {
        let gradient = GradientView(colors: [.clear, Color.black.withAlphaComponent(0.8)])
        gradient.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(gradient)
        return gradient
    }()
}

extension GenericFeedCell {
    /// The UI layout here is **constant** which will always be the same, as only so many UICollectionViewCells are initialized in total.
    func setupUI() {
        backgroundColor = .clear
        layoutContainer()
        layoutCoverImageView()
        layoutBlurView()
//        layoutGradientView()
    }
}

private extension GenericFeedCell {
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
    
    func layoutGradientView() {
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
        ])
    }
}

private extension GenericFeedCell {
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
