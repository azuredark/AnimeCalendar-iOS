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

    var section: FeedSection?

    private var isAnimating: Bool = false

    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.black.withAlphaComponent(0.2)
        view.addCornerRadius(radius: 10.0)
        view.layer.borderColor = Color.white.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 4.0
        contentView.addSubview(view)
        return view
    }()

    private lazy var loadMoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        label.text = "+"
        label.textColor = Color.cream
        label.numberOfLines = 1
        containerView.addSubview(label)
        return label
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        return activityIndicator
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
    func setup(with sectionsState: FeedSectionsState) {
        #warning("This should not be executed on each setup")
        containerView.expand(durationInSeconds: 1.5,
                             end: .reset,
                             toScale: 0.95,
                             options: [.repeat, .autoreverse, .allowUserInteraction])
    }

    func startLoadingAnimation() {
        isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.loadMoreLabel.alpha = 0
            self?.activityIndicatorView.alpha = 1.0

        } completion: { [weak self] _ in
            self?.activityIndicatorView.isHidden = false
            self?.loadMoreLabel.isHidden = true
        }
    }

    func stopLoadingAnimation() {
        isUserInteractionEnabled = true
        activityIndicatorView.alpha = 0
        activityIndicatorView.isHidden = true

        loadMoreLabel.alpha = 1
        loadMoreLabel.isHidden = false

        activityIndicatorView.stopAnimating()
    }
}

private extension ACLoadMoreItemsCell {
    func handleState(_ feedSectionsState: FeedSectionsState) {
        guard let section, let sectionState = feedSectionsState[section]?.state else { return }

        if case .requesting = sectionState {}
    }
}

private extension ACLoadMoreItemsCell {
    func layoutUI() {
        contentView.addCornerRadius(radius: 10.0)
        layoutContainerView()
        layoutLoadMoreLabel()
        layoutRefreshControl()
    }

    func layoutContainerView() {
        let padding: CGFloat = 0
        containerView.fitViewTo(contentView, padding: padding)
    }

    func layoutLoadMoreLabel() {
        NSLayoutConstraint.activate([
            loadMoreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadMoreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    func layoutRefreshControl() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
