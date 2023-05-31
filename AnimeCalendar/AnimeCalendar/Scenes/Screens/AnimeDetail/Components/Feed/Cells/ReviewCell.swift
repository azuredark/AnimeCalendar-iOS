//
//  ReviewCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

final class ReviewCell: UICollectionViewCell, FeedCell {
    // MARK: State
    weak var reviewInfo: ReviewInfo?
    
    private let headerViewHeight: CGFloat = 40.0
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        contentView.addSubview(view)
        return view
    }()
    
    private var authorImageViewSize: CGSize { CGSize(width: headerViewHeight, height: headerViewHeight) }
    private lazy var authorImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.lightGray
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Color.cobalt.cgColor
        
        headerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.black
        label.font = ACFont.bold.sectionTitle3
        label.numberOfLines = 1
        label.textAlignment = .left
        
        headerView.addSubview(label)
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = Color.lightGray
        textView.font = ACFont.medium1
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.numberOfLines = 5
        
        contentView.addSubview(textView)
        return textView
    }()
    
    private lazy var reviewTagView: IconLabelView = {
        let view = IconLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(view)
        return view
    }()
    
    private lazy var ratingView: IconLabelView = {
        let view = IconLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(view)
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        authorNameLabel.text = nil
        reviewLabel.text = nil
        authorImageView.image = nil
        reviewTagView.reset()
        ratingView.reset()
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
        authorNameLabel.text = reviewInfo?.user?.username
        reviewLabel.text = reviewInfo?.review
        
        let imagePath = reviewInfo?.user?.images?.jpgImage.attemptToGetImageByResolution(.small)
        authorImageView.loadImage(from: imagePath, size: authorImageViewSize, options: [.disableDiskCache, .disableMemoryCache])
        
        // ReviewTagView.
        configureReviewTagView()
        // RatingView
        configureRatingView()
    }
}

private extension ReviewCell {
    func configureReviewTagView() {
        guard let reviewInfo else { return }
        
        let allowedTags: [ReviewTag] = [.recommended, .mixedFeedlings, .notRecommended, .preliminary]
        
        guard let tag = reviewInfo.tags.first(where: { allowedTags.contains($0) }) else { return }
        
        let model = IconLabelModel(iconLabelType: .tag(tag))
        reviewTagView.setup(tagModel: model)
    }
    
    func configureRatingView() {
        guard let rating = reviewInfo?.score else { return }
        
        let model = IconLabelModel(iconLabelType: .rating(rating))
        ratingView.setup(tagModel: model)
    }
}

private extension ReviewCell {
    func layoutUI() {
        configureSubviews()
        
        // Header view.
        layoutHeaderView()
        layoutUserImageView()
        layoutAuthorNameLabel()
        layoutReviewTagView()
        layoutRatingView()
        
        // Content view.
        layoutReviewLabel()
    }
    
    func configureSubviews() {
        contentView.backgroundColor = Color.cobalt.withAlphaComponent(0.20)
        backgroundColor = .clear
        contentView.addCornerRadius(radius: 10.0)
    }
    
    // Header view.
    func layoutHeaderView() {
        let yPadding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yPadding),
        ])
    }
    
    func layoutUserImageView() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            authorImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: xPadding),
            authorImageView.widthAnchor.constraint(equalToConstant: authorImageViewSize.width),
            authorImageView.heightAnchor.constraint(equalToConstant: authorImageViewSize.height),
            
            authorImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: yPadding),
            authorImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -yPadding)
        ])
        
        authorImageView.addCornerRadius(radius: headerViewHeight / 2)
    }
    
    func layoutAuthorNameLabel() {
        let xPadding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: xPadding),
            authorNameLabel.topAnchor.constraint(equalTo: authorImageView.topAnchor)
        ])
    }
    
    func layoutReviewTagView() {
        // Constraint
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 3.0
        NSLayoutConstraint.activate([
            reviewTagView.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: xPadding),
            reviewTagView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: yPadding),
        ])
    }
    
    func layoutRatingView() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            ratingView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -xPadding),
            ratingView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: yPadding)
        ])
    }
    
    // Content view.
    func layoutReviewLabel() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 5.0
        NSLayoutConstraint.activate([
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xPadding),
            reviewLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xPadding),
            reviewLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: yPadding),
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yPadding)
        ])
    }
}
