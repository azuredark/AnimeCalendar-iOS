//
//  GenericFeedCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 22/11/22.
//

import UIKit

protocol FeedCell {
    associatedtype T: Decodable
    static var reuseIdentifier: String { get set }
    func setup(item: T)
}

class GenericFeedCell: UICollectionViewCell {
    // MARK: State
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.black
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()

    // MARK: Initializers
}

extension GenericFeedCell {
    func setupUI() {
        layoutTitleLabel()
        contentView.backgroundColor = Color.pink
    }

    func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
