//
//  BasicInfoCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

fileprivate enum AccessId: String {
    case titleLabel = "title_label"
    case synopsisLabel = "synopsis_label"
}

final class BasicInfoCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "DETAIL_FEED_BASIC_INFO_CELL_REUSE_ID"

    var anime: Anime? {
        didSet { setupUI() }
    }

    /// Title label.
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = Color.black
        label.accessibilityIdentifier = AccessId.titleLabel.rawValue
        contentView.addSubview(label)
        return label
    }()

    /// Details (Year, score, community, studio, etc)

    /// Synopsis label.
    private lazy var synopsisLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = Color.gray
        label.accessibilityIdentifier = AccessId.synopsisLabel.rawValue
        contentView.addSubview(label)
        return label
    }()

    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        synopsisLabel.text = nil
    }

    func setup() {
        titleLabel.text = anime?.titleEng
        synopsisLabel.text = anime?.synopsis
    }
}

private extension BasicInfoCell {
    func setupUI() {
        layoutTitle()
        layoutSynopsis()
    }
    
    func layoutTitle() {
        let xInset = 10.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xInset),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    func layoutSynopsis() {
        let xInset = 10.0
        NSLayoutConstraint.activate([
            synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xInset),
            synopsisLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xInset),
            synopsisLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            synopsisLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5.0)
        ])
    }
}
