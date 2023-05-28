//
//  FeedHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/11/22.
//

import UIKit

final class FeedHeader: UICollectionReusableView {
    static let reuseIdentifier = "HEADER_REUSE_IDENTIFIER"
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerTitleLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layoutHeaderLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(with model: FeedHeaderModel) {
        configureHeaderTitle(with: model.title)
    }
}

private extension FeedHeader {
    func configureHeaderTitle(with model: FeedHeaderTitleModel) {
        headerTitleLabel.font          = model.font
        headerTitleLabel.textColor     = model.color
        headerTitleLabel.textAlignment = model.alignment
        headerTitleLabel.text          = model.text
    }
}

private extension FeedHeader {
    func layoutHeaderLabel() {
        let inset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            headerTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}

struct FeedHeaderModel {
    var title: FeedHeaderTitleModel
    
    init(text: String) {
        title = FeedHeaderTitleModel(text: text)
    }
}

struct FeedHeaderTitleModel {
    var font: UIFont = ACFont.bold.medium1
    var color: UIColor = Color.black
    var alignment: NSTextAlignment = .left
    var text: String = ""
}
