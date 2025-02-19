//
//  CharacterCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 10/02/23.
//

import UIKit

final class CharacterCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "CHARACTER_CELL_REUSE_ID"
    
    var characterInfo: CharacterInfo?
    
    private var overlayApplied: Bool = false

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        contentView.addSubview(imageView)
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.staticWhite
        label.font = .systemFont(ofSize: 16.0, weight: .light)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.alpha = 0

        // Shadow
        label.layer.shadowColor = Color.staticBlack.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false

        contentView.addSubview(label)
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !overlayApplied {
            applyOverlay()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameLabel.text = nil
    }

    // MARK: Methods
    func setup() {
        setupCoverImageView()
        setupLabel()
    }
}

private extension CharacterCell {
    func setupCoverImageView() {
        guard let imgPath = characterInfo?.character.imageType?.webpImage.attemptToGetImageByResolution(.normal) else { return }
        coverImageView.loadImage(from: imgPath, cellType: self, options: [.disableDiskCache]) { [weak self] (_,_) in
            UIView.animate(withDuration: 0.4) {
                self?.nameLabel.alpha = 1
            }
        }
    }

    func setupLabel() {
        guard let character = characterInfo?.character, !character.name.isEmpty else { return }
        nameLabel.text = character.name
    }
}

private extension CharacterCell {
    func layoutUI() {
        contentView.addCornerRadius(radius: 5.0)
        contentView.clipsToBounds = true

        layoutCoverImageView()
        layoutNameLabel()
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func layoutNameLabel() {
        let padding: CGFloat = 4.0
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    func applyOverlay() {
        let gradient = CAGradientLayer()

        gradient.colors = [UIColor.clear.cgColor, Color.staticBlack.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 1)
        gradient.frame = contentView.bounds

        contentView.layer.insertSublayer(gradient, above: coverImageView.layer)
        overlayApplied = true
    }
}
