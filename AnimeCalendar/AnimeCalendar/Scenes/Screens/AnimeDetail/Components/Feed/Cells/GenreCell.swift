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
    
    var genre: AnimeGenre? {
        didSet { layoutUI() }
    }
    
    /// Contains the whole cell
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = Color.cobalt
        label.numberOfLines = 1
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
            nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: xInset),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -xInset)
        ])
    }
}
