//
//  GenericFeedCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol CellReusable: UICollectionViewCell {
    static var reuseIdentifier: String { get }
}

extension CellReusable {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

protocol FeedCell: CellReusable {
    /// Unique Identifier for properly reusing cells
    static var reuseIdentifier: String { get }
    /// Sets up the cell with **dynamic** values *(Will update depending on the cell)*.
    func setup()
    func getCoverImage() -> UIImage?
}

extension FeedCell {
    func setup() { }
    func getCoverImage() -> UIImage? { return nil }
}

class GenericFeedCell: UICollectionViewCell {
    // MARK: Accessibility id
    private let accessId = GenericFeedCellIdentifiers()
    private var radius: CGFloat { 5.0 }

    // MARK: State
    private var shadowExists: Bool = false
    
    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addCornerRadius(radius: radius)
        contentView.addSubview(view)
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
        layoutCoverImageView()
        layoutBlurView()
    }
}

private extension GenericFeedCell {
    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
            let shadow = ShadowBuilder().getTemplate(type: .full)
                .with(opacity: 0.25)
                .with(cornerRadius: radius)
                .build()
            shadowExists = true
        }
    }
}
