//
//  FeedHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/11/22.
//

import UIKit

final class FeedHeader: UICollectionReusableView {
    static let reuseIdentifier = "HEADER_REUSE_IDENTIFIER"

    private lazy var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Color.black
        label.font = ACFont.bold.medium1
        label.textAlignment = .left
        addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layoutHeader()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupTitle(with text: String) {
        headerLabel.text = text
    }
}

extension FeedHeader {
    func layoutHeader() {
        let inset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
