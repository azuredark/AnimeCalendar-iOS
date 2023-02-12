//
//  SpinnerCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/02/23.
//

import UIKit


final class SpinnerCell: UICollectionViewCell {
    // MARK: State
    private lazy var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
        return spinner
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutProgress()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        if !spinnerView.isAnimating {
            spinnerView.startAnimating()
        }
    }
}

private extension SpinnerCell {
    func layoutProgress() {
        let side: CGFloat = 100.0
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: side),
            spinnerView.heightAnchor.constraint(equalToConstant: side)
        ])
    }
}
