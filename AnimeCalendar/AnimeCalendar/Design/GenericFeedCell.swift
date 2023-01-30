//
//  GenericFeedCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedCell {
    /// Unique Identifier for properly reusing cells
    static var reuseIdentifier: String { get set }
    /// Sets up the cell with **dynamic** values *(Will update depending on the cell)*.
    func setup()
}

class GenericFeedCell: UICollectionViewCell {
    // MARK: Accessibility id
    private let accessId = GenericFeedCellIdentifiers()
    private var radius: CGFloat { 5.0 }

    // MARK: State
    private var shadowExists: Bool = false

    private(set) lazy var mainContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        container.accessibilityIdentifier = accessId.containerId
        contentView.addSubview(container)
        return container
    }()

    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addCornerRadius(radius: radius)
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

}

extension GenericFeedCell {
    /// The UI layout here is **constant** which will always be the same, as only so many UICollectionViewCells are initialized in total.
    func layoutUI() {
        backgroundColor = .clear
        layoutContainer()
        layoutCoverImageView()
        layoutBlurView()
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
}

private extension GenericFeedCell {
    func configureContainerShadow() {
        if !shadowExists {
            mainContainer.setNeedsLayout()
            mainContainer.layoutIfNeeded()
            let shadow = ShadowBuilder().getTemplate(type: .full)
                .with(opacity: 0.25)
                .with(cornerRadius: radius)
                .build()
            mainContainer.addShadow(with: shadow)
            shadowExists = true
        }
    }
}
