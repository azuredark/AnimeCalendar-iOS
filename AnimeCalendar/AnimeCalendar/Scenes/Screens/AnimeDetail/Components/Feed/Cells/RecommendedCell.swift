//
//  RecommendedCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 31/05/23.
//

import UIKit

final class RecommendedCell: UICollectionViewCell, FeedCell {
    // MARK: State
    weak var animeInfo: RecommendationInfo?
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.cobalt.withAlphaComponent(0.2)
        imageView.addCornerRadius(radius: 3.0)
        
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ACFont.regular1
        label.textAlignment = .left
        label.textColor = Color.black
        label.lineBreakMode = .byTruncatingTail
        
        contentView.addSubview(label)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setup() {
        titleLabel.text = animeInfo?.anime?.titleEng
        
        let imagePath = animeInfo?.anime?.imageType?.webpImage.attemptToGetImageByResolution(.normal)
        coverImageView.loadImage(from: imagePath, cellType: self, options: [.disableDiskCache])
    }
    
    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension RecommendedCell {
    func layoutUI() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        
        layoutTitleLabel()
        layoutCoverImageView()
    }
    
    func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    }
}
