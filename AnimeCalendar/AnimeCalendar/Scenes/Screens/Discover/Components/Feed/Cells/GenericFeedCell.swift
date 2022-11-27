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

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        mainContainer.addSubview(label)
        return label
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
}

extension GenericFeedCell {
    func setupUI() {
        backgroundColor = .clear
        layoutContainer()
        layoutCoverImageView()
        layoutTitleBlurContainerView()
        layoutTitleLabel()
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

private extension GenericFeedCell {
    func configureContainerShadow() {
        if !shadowExists {
            mainContainer.setNeedsLayout()
            mainContainer.layoutIfNeeded()
            let shadow = ShadowBuilder().getTemplate(type: .bottom)
                .with(opacity: 0.20)
                .with(cornerRadius: 10.0)
                .build()
            mainContainer.addShadow(with: shadow)
            shadowExists = true
        }
    }
}
