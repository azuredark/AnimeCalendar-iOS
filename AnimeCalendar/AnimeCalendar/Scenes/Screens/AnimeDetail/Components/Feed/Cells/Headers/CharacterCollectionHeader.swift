//
//  CharacterCollectionHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/02/23.
//

import UIKit

final class CharacterColletionHeader: UICollectionReusableView, FeedHeaderProtocol {
    // MARK: State
    static var reuseIdentifier: String = "CHARACTER_COLLECTION_HEADER_REUSE_ID"
    static var sectionHeaderKind: String = "CHARACTER_COLLECTION_HEADER_KIND"

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = Color.gray
        label.font = ACFont.bold.sectionTitle2
        label.text = "Characters"
        addSubview(label)
        return label
    }()

    private lazy var lineSpacerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.gray5
        addSubview(view)
        return view
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

    // MARK: Methods
    func setup() {}
}

private extension CharacterColletionHeader {
    func layoutUI() {
        layoutLineSpacerView()
        layoutTitleLabel()
    }

    func layoutLineSpacerView() {
        /// # MAKE WIDTH OUTSIDE THE SUPERVIEW TO SHOW THE FULL LINE SPACER
        let height: CGFloat = 5.0
        NSLayoutConstraint.activate([
            lineSpacerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineSpacerView.topAnchor.constraint(equalTo: topAnchor),
            lineSpacerView.heightAnchor.constraint(equalToConstant: height),
            lineSpacerView.widthAnchor.constraint(equalTo: widthAnchor, constant: 15.0)
        ])
    }

    func layoutTitleLabel() {
        let yInset: CGFloat = 4.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: lineSpacerView.bottomAnchor, constant: yInset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yInset)
        ])
    }
}
