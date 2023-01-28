//
//  ACScroll.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/01/23.
//

import UIKit

enum ACScrollAxis {
    case vertical
    case horizontal
}

final class ACSCroll: UIScrollView {
    // MARK: State
    private(set) var axis: ACScrollAxis

    // MARK: Initializers
    /// Creates a *UIScrollView* wrapper with an *axis*.
    /// - Parameter axis: The axis of the *UIScrollView*.
    init(axis: ACScrollAxis) {
        self.axis = axis
        
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Client must pass the **container** view which holds all the other subviews that will be inside the *ACScroll*.
    /// - Parameter innerView: The inner or *container* view which **holds all the other subviews** that will be inside the *UIScrollView*.
    func setup(with innerView: UIView) {
        build(with: innerView)
    }
}

private extension ACSCroll {
    func configure() {
        isDirectionalLockEnabled = true
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
    }
    
    func build(with innerView: UIView) {
        layoutContainer(container: innerView)
    }

    func layoutContainer(container view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let xPadding: CGFloat = 0
        let yPadding: CGFloat = 0
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xPadding),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xPadding),
            view.topAnchor.constraint(equalTo: topAnchor, constant: yPadding),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yPadding)
        ])

        // Set scrolling bounds by axis.
        let heightConstraint: NSLayoutConstraint = view.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor, constant: -xPadding * 2)
        let widthConstraint: NSLayoutConstraint = view.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor, constant: -yPadding * 2)
        
        let axisIsVertical: Bool = (axis == .vertical)
        view.setPriorityForConstraints([axisIsVertical ? widthConstraint : heightConstraint], with: .required)
        view.setPriorityForConstraints([!axisIsVertical ? widthConstraint : heightConstraint], with: .defaultLow)
    }
}
