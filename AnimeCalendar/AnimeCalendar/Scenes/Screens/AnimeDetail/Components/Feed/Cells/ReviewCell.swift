//
//  ReviewCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

final class ReviewCell: UICollectionViewCell, ACReusable {
    // MARK: State
    weak var reviewInfo: ReviewInfo?
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.black
        label.font = ACFont.medium1
        label.numberOfLines = 1
        label.textAlignment = .left
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.lightGray
        label.font = ACFont.medium1
        label.numberOfLines = 0
        label.textAlignment = .justified
        
        contentView.addSubview(label)
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        reviewLabel.text = nil
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func setup() {
        authorLabel.text = reviewInfo?.user?.username
        reviewLabel.text = reviewInfo?.review
    }
}

private extension ReviewCell {
    func layoutUI() {
        configureSubviews()
        
        layoutAuthorLabel()
        layoutReviewLabel()
    }
    
    func configureSubviews() {
        contentView.backgroundColor = Color.cobalt.withAlphaComponent(0.20)
        backgroundColor = .clear
        contentView.addCornerRadius(radius: 10.0)
    }
    
    func layoutAuthorLabel() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xPadding),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xPadding),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yPadding)
        ])
    }
    
    func layoutReviewLabel() {
        let yPadding: CGFloat = 5.0
        let xPadding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xPadding),
            reviewLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xPadding),
            reviewLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: yPadding),
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yPadding)
        ])
    }
}
