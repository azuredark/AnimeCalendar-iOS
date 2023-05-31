//
//  IconLabelView.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/23.
//

import UIKit

final class IconLabelView: UIView {
    // MARK: State
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = ACFont.bold.regular1
        label.numberOfLines = 1
        
        addSubview(label)
        return label
    }()
    
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(tagModel: IconLabelModel) {
        textLabel.text = tagModel.text
        textLabel.textColor = tagModel.textColor
        iconImageView.image = tagModel.icon
        backgroundColor = tagModel.bgColor
        
        addCornerRadius(radius: tagModel.cornerRadius)
    }
    
    func reset() {
        textLabel.text = nil
        iconImageView.image = nil
        layer.cornerRadius = 0
    }
}

private extension IconLabelView {
    func layoutUI() {
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
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: leadingPadding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPadding),
            textLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
        ])
    }
}

struct IconLabelModel {
    enum IconLabel {
        case tag(_ reviewTag: ReviewTag)
        case rating(_ rating: Int)
    }
    
    var bgColor: UIColor = .clear
    var icon = UIImage()
    var text: String = ""
    var textColor: UIColor = Color.lightGray
    var font: UIFont = ACFont.bold.regular1
    var cornerRadius: CGFloat = 0
    var innerSpacing: CGFloat = 3.0
    
    init(iconLabelType: IconLabel) {
        switch iconLabelType {
            case .tag(let tag):
                configureForTag(with: tag)
            case .rating(let value):
                configureForRating(with: value)
        }
    }
    
    mutating private func configureForTag(with tag: ReviewTag) {
        var img = UIImage()
        
        switch tag {
            case .recommended:
                textColor = Color.blue
                bgColor = textColor.withAlphaComponent(0.2)
                img = ACIcon.faStarFilled
                img = img.withTintColor(Color.blue, renderingMode: .alwaysOriginal)
            case .mixedFeedlings:
                textColor = Color.lightGray
                bgColor = textColor.withAlphaComponent(0.2)
                img = ACIcon.faStarFilledHalf
                img = img.withTintColor(Color.lightGray, renderingMode: .alwaysOriginal)
            case .notRecommended:
                textColor = Color.red
                bgColor = textColor.withAlphaComponent(0.2)
                img = ACIcon.faStar
                img = img.withTintColor(Color.red, renderingMode: .alwaysOriginal)
            case .preliminary:
                textColor = Color.lightGray
                bgColor = .clear
                img = ACIcon.faClock
                img = img.withTintColor(Color.lightGray, renderingMode: .alwaysOriginal)
            default: break
        }
        
        text = tag.rawValue
        icon = img
    }
    
    
    mutating private func configureForRating(with rating: Int) {
        textColor = Color.black
        bgColor = Color.cobalt.withAlphaComponent(0.2)
        text = "\(rating)"
        
        let img = ACIcon.faStarFilled
        icon = img.withTintColor(Color.yellow, renderingMode: .alwaysOriginal)
        cornerRadius = 5.0
        innerSpacing = 5.0
    }
    
}
