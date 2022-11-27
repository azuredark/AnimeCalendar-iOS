//
//  AnimeCellTag.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

final class AnimeCellTag: UIView {
    // MARK: State
    private var config: AnimeCellTag.Config

    private lazy var blurContainerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.opacity = 0.85
        addSubview(blurView)
        return blurView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Color.white
        addSubview(imageView)
        return imageView
    }()

    private lazy var iconTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = Color.white
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 1
        addSubview(label)
        return label
    }()

    // MARK: Initializers
    init(config: AnimeCellTag.Config, frame: CGRect = .zero) {
        self.config = config

        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnimeCellTag {
    func setupUI() {
        layoutBlurContainerView()
        layoutIconImageView()
        layoutIconTextLabel()
    }

    func layoutBlurContainerView() {
        NSLayoutConstraint.activate([
            blurContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurContainerView.topAnchor.constraint(equalTo: topAnchor),
            blurContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func layoutIconImageView() {
        iconImageView.image = config.iconImage

        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: blurContainerView.leadingAnchor, constant: xInset),
            iconImageView.heightAnchor.constraint(equalToConstant: 12.0),
            iconImageView.widthAnchor.constraint(equalToConstant: 11.0),
            iconImageView.centerYAnchor.constraint(equalTo: blurContainerView.centerYAnchor)
        ])
    }

    func layoutIconTextLabel() {
        iconTextLabel.text = config.iconText

        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            iconTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: xInset),
            iconTextLabel.centerYAnchor.constraint(equalTo: blurContainerView.centerYAnchor)
        ])
    }
}

extension AnimeCellTag {
    struct Config {
        var iconImage: UIImage
        var iconText: String

        init(iconImage: UIImage, iconText: String?) {
            self.iconImage = iconImage
            self.iconText = iconText ?? ""
        }
    }
}

enum AnimeTag {
    case episodes(value: Int)
    case score(value: CGFloat)
    case rank(value: Int)
}
