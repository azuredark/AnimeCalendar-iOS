//
//  ACLoaderCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 10/03/23.
//

import UIKit

class ACLoaderCell: UICollectionViewCell, FeedCell {
    static var reuseIdentifier: String = "AC_LOADER_CELL"

    // MARK: State
    private var didLayoutSubviews: Bool = false

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
    func setup() {
        if !didLayoutSubviews {
            layoutIfNeeded()
            layoutGradientLayer()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension ACLoaderCell {
    /// Layout **static** UI.
    func layoutUI() {
        contentView.clipsToBounds = true
        contentView.addCornerRadius(radius: 10.0)
    }

    func layoutGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = 10.0
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        contentView.layer.insertSublayer(gradientLayer, above: contentView.layer)
        didLayoutSubviews = true

        let animationGroup = getAnimationGroup()
        gradientLayer.add(animationGroup, forKey: "backgroundColor")
    }

    /// Animate the background giving a *shimmer* effect.
    func getAnimationGroup() -> CAAnimationGroup {
        let duration: CFTimeInterval = 1.5
        let animation1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        animation1.fromValue = Color.lightGray.withAlphaComponent(0.4).cgColor
        animation1.toValue = Color.cobalt.withAlphaComponent(0.4).cgColor
        animation1.duration = duration
        animation1.beginTime = 0.0

        let animation2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        animation2.fromValue = Color.cobalt.withAlphaComponent(0.4).cgColor
        animation2.toValue = Color.lightGray.withAlphaComponent(0.4).cgColor
        animation2.duration = duration
        animation2.beginTime = animation1.beginTime + animation1.duration

        // Animation Group
        let group = CAAnimationGroup()
        group.animations = [animation1, animation2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = animation1.duration + animation2.duration
        group.isRemovedOnCompletion = false
        group.beginTime = 0.0

        return group
    }
}
