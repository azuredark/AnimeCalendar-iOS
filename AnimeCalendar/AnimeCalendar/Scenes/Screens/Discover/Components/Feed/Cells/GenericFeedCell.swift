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

    private lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.white
        container.accessibilityIdentifier = accessId.containerId
        contentView.addSubview(container)
        return container
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.black
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        container.addSubview(label)
        return label
    }()
}

extension GenericFeedCell {
    func setupUI() {
        backgroundColor = .clear
        layoutContainer()
        layoutTitleLabel()
    }
}

private extension GenericFeedCell {
    func layoutContainer() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        configureContainerShadow()
    }

    func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

    func configureContainerShadow() {
        if !shadowExists {
            container.setNeedsLayout()
            container.layoutIfNeeded()
            let shadow = ShadowBuilder().getTemplate(type: .full)
                .with(opacity: 0.20)
                .with(cornerRadius: 10.0)
                .build()
            container.addShadow(with: shadow)
            shadowExists = true
        }
    }
}
