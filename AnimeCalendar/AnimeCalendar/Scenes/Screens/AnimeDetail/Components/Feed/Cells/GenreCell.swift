//
//  GenreCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/01/23.
//

import UIKit

final class GenreCell: UICollectionViewCell, FeedCell {
    
    // MARK: State
    static var reuseIdentifier: String = "GENRE_CELL_REUSE_IDENTIFIER"
    private typealias AccessId = GenreCellIdentifiers
    
    var genre: AnimeGenre? {
        didSet { layoutUI() }
    }
    
    /// Contains the whole cell
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessId.container
        view.backgroundColor = Color.cobalt.withAlphaComponent(0.20)
        view.layer.borderColor = Color.cobalt.withAlphaComponent(0.20).cgColor
        view.layer.borderWidth = 1.0
        view.addCornerRadius(radius: 5.0)
        contentView.addSubview(view)
        return view
    }()
    
    /// Genre's name.
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.nameLabel
        label.font = .systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = Color.cobalt
        label.numberOfLines = 1
        label.textAlignment = .center
        container.addSubview(label)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }

    // MARK: Methods
    /// Setup dynamic cell values.
    func setup() {
        nameLabel.text = genre?.name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = AccessId.cell
        contentView.accessibilityIdentifier = AccessId.contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GenreCell {
    /// For static UI components which will not change regardless of the cell.
    func layoutUI() {
        contentView.backgroundColor = .clear
        layoutContainer()
        layoutNameLabel()
    }
    
    func layoutContainer() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func layoutNameLabel() {
        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        /// # When working with `dynamic` cell sizes or any `constraint` which is calculated in `run-time`,
        /// # sometimes the UI component used, in this case UICompositionalLayout with `estimated sizes`,
        /// # will pre-set `default constraints` in `build-time` which may interfere to the manual constraints set.
        
        /// # In this case the `xInset` takes an inset value of `5.0` without actually knowing for sure if the `container`'s
        /// # width/height as it depends on the `contentView` which is calculated in `run-time` with the `estimated`
        /// # width of the `NSCollectionLayoutSection` that is again calculated by the `content-size` of the `label`.
        let leadingConstraint = nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: xInset)
        leadingConstraint.priority = .defaultHigh
        leadingConstraint.isActive = true
        
        let trailingConstraint = nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -xInset)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true
    }
}
