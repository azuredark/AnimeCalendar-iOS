//
//  BlurContainer.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/11/22.
//

import UIKit

final class BlurContainer: UIView {
    // MARK: State

    private var titleLabel: UILabel?
    private let config: BlurContainer.Config

    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        addSubview(view)
        return view
    }()

    // MARK: Initializers
    init(config: BlurContainer.Config, frame: CGRect = .zero) {
        self.config = config
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    private func setup() {
        blurView.alpha = config.opacity
        layoutBlurView()
    }

    /// Configure the BlurContainer with a title
    /// - Parameter title: Text to add to the container.
    /// - Parameter lines: Max. number of lines of the label.
    func configure(with title: String, lines: Int) {
        layoutTitle(title: title, lines: lines)
    }

    /// **Must** be called before configuring the view again, recommended to call in *prepareForReuse()*
    func reset() {
        titleLabel?.text = nil
        titleLabel?.removeFromSuperview()
    }
}

private extension BlurContainer {
    func layoutTitle(title: String, lines: Int) {
        let titleLabel = UILabel(frame: .zero)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Color.white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = lines
        titleLabel.text = title

        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xInset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        self.titleLabel = titleLabel
    }

    func layoutBlurView() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension BlurContainer {
    struct Config {
        var opacity: CGFloat

        init(opacity: CGFloat) {
            self.opacity = opacity
        }
    }
}
