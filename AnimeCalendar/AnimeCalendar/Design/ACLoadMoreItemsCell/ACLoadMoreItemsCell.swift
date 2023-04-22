//
//  ACLoadMoreItemsCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 20/03/23.
//

import UIKit

final class ACLoadMoreItemsCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "AC_LOAD_MORE_ITEMS_CELL"

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
        return spinner
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.stopAnimating()
    }

    // MARK: Methods
    func setup() {
        activityIndicatorView.startAnimating()
    }
}

private extension ACLoadMoreItemsCell {
    func layoutUI() {
        contentView.addCornerRadius(radius: 5.0)
        contentView.backgroundColor = Color.gray5
        
        layoutActivityIndicatorView()
    }

    func layoutActivityIndicatorView() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        activityIndicatorView.setSize(width: 50.0, height: 50.0)
    }
}
