//
//  DetailFeedHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import UIKit

final class DetailFeedHeader: UICollectionReusableView {
    // MARK: State
    static let reuseId = String(describing: DetailFeedHeader.self)
    
    private lazy var separatorView: AnimeDetailSeparatorView = {
        let view = AnimeDetailSeparatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
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
    func setup(with model: FeedHeaderModel) {
        configureHeaderTitle(with: model.title)
    }
}

private extension DetailFeedHeader {
    func configureHeaderTitle(with model: FeedHeaderTitleModel) {
        titleLabel.font          = model.font
        titleLabel.textColor     = model.color
        titleLabel.textAlignment = model.alignment
        titleLabel.text          = model.text
    }
}

private extension DetailFeedHeader {
    func layoutUI() {
        layoutSeparatorView()
        layoutTitleLabel()
    }
    
    func layoutSeparatorView() {
        let height: CGFloat   = 5.0
        let yPadding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: yPadding),
            separatorView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func layoutTitleLabel() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -xPadding),
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: yPadding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yPadding)
        ])
    }
}
