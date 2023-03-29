//
//  AnimeCellTag.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import UIKit

final class AnimeCellTag: UIView {
    // MARK: State
    var config: AnimeCellTag.Config
    
    private var hasDifferenteCorners: Bool = false
    
    private lazy var mainContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        addSubview(view)
        return view
    }()

    private lazy var blurContainerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        mainContainer.addSubview(blurView)
        return blurView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        mainContainer.addSubview(imageView)
        return imageView
    }()

    private lazy var iconTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.numberOfLines = 1
        mainContainer.addSubview(label)
        return label
    }()

    // MARK: Initializers
    init(config: AnimeCellTag.Config, frame: CGRect = .zero) {
        self.config = config

        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !hasDifferenteCorners {
            mainContainer.addCornerRadius(radius: config.radius, corners: config.corners)
            hasDifferenteCorners = true
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnimeCellTag {
    func setupUI() {
        layoutMainContainer()
        layoutBlurContainerView()
        layoutIconImageView()
        layoutIconTextLabel()
    }
    
    func layoutMainContainer() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func layoutBlurContainerView() {
        NSLayoutConstraint.activate([
            blurContainerView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            blurContainerView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            blurContainerView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            blurContainerView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }

    func layoutIconImageView() {
        iconImageView.image = config.iconImage
        iconImageView.tintColor = config.iconColor

        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: xInset),
            iconImageView.heightAnchor.constraint(equalToConstant: 12.0),
            iconImageView.widthAnchor.constraint(equalToConstant: 11.0),
            iconImageView.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor)
        ])
    }

    func layoutIconTextLabel() {
        iconTextLabel.text = config.iconText
        iconTextLabel.textColor = config.iconColor

        let xInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            iconTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: xInset),
            iconTextLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -xInset),
            iconTextLabel.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor)
        ])
    }
}

extension AnimeCellTag {
    struct Config {
        var iconImage: UIImage
        var iconText: String
        var iconColor: UIColor
        var corners: UIRectCorner = .allCorners
        var radius: CGFloat = 5.0

        init(iconImage: UIImage, iconText: String?, iconColor: UIColor) {
            self.iconImage = iconImage
            self.iconText = iconText ?? ""
            self.iconColor = iconColor
        }
    }
}

enum AnimeTag {
    case episodes(value: Int)
    case score(value: CGFloat)
    case rank(value: Int)
}
