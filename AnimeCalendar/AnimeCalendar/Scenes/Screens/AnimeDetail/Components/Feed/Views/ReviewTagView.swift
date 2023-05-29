//
//  ReviewTagView.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/23.
//

import UIKit

final class ReviewTagView: UIView {
    // MARK: State
    private let tagModel: ReviewTagModel
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = tagModel.icon
        
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var decisionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = ACFont.bold.regular1
        label.textColor = tagModel.color
        label.numberOfLines = 1
        label.text = tagModel.tag.rawValue
        
        addSubview(label)
        return label
    }()
    
    // MARK: Initializers
    init(tagModel: ReviewTagModel) {
        self.tagModel = tagModel
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ReviewTagView {
    func layoutUI() {
        backgroundColor = tagModel.color.withAlphaComponent(0.2)
        
        layoutIconImageView()
        layoutDecisionLabel()
    }
    
    func layoutIconImageView() {
        let side: CGFloat = 12.0
        let padding: CGFloat = 3.0
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconImageView.widthAnchor.constraint(equalToConstant: side),
            iconImageView.heightAnchor.constraint(equalToConstant: side),
            
            // Make the super-view adapt to the size.
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    func layoutDecisionLabel() {
        let leadingPadding: CGFloat  = 5.0
        let trailingPadding: CGFloat = 3.0
        NSLayoutConstraint.activate([
            decisionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: leadingPadding),
            decisionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPadding),
            decisionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

struct ReviewTagModel {
    var tag: ReviewTag = .unknown
    var icon = UIImage()
    var color: UIColor = .clear
    
    init(tag: ReviewTag) {
        self.tag = tag
        
        makeTagIcon(with: tag)
    }
    
    mutating private func makeTagIcon(with tag: ReviewTag) {
        var img = UIImage()
        
        switch tag {
            case .recommended:
                color = Color.blue
                img = ACIcon.faStarFilled
                img = img.withTintColor(color, renderingMode: .alwaysOriginal)
            case .mixedFeedlings:
                color = Color.lightGray
                img = ACIcon.faStarFilledHalf
                img = img.withTintColor(color, renderingMode: .alwaysOriginal)
            case .notRecommended:
                color = Color.red
                img = ACIcon.faStar
                img = img.withTintColor(color, renderingMode: .alwaysOriginal)
            default: break
        }
        
        icon = img
    }
}
