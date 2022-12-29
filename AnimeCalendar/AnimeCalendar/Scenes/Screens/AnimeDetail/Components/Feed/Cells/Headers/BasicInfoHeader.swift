//
//  BasicInfoHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/12/22.
//

import UIKit

final class BasicInfoHeader: UICollectionReusableView {
    // MARK: State
    static let reuseIdentifier = "HEADER_REUSE_IDENTIFIER"
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        addSubview(label)
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layoutHeader()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
    }

    // MARK: Methods
    func setupTitle(with text: String) {
        headerLabel.text = text
    }
}

private extension BasicInfoHeader {
    func layoutHeader() {
        let yInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: yInset),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yInset)
        ])
    }
}
