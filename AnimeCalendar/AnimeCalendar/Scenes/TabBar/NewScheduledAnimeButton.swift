//
//  NewScheduledAnimeButton.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/05/22.
//

import UIKit

final class NewScheduledAnimeButton: TabBarButton {
    var button = UIButton(type: .system)
    var onTapAction: (() -> Void)?
}

extension NewScheduledAnimeButton {
    func createButton(in tabBarView: UITabBar) {
        configureButton(tabBarView)
        configureConstraints(tabBarView)
    }

    // Button's action
    @objc func presentNewScheduledAnimeScreen() {
        print("Button + pressed")
        onTapAction?()
    }
}

private extension NewScheduledAnimeButton {
    func configureButton(_ tabBarView: UIView) {
        // Configure for AutoLayout
        button.translatesAutoresizingMaskIntoConstraints = false

        // Button image
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)!
        button.setImage(image, for: .normal)
        button.backgroundColor = Color.pink
        button.tintColor = Color.white
        
        let shadow = ShadowBuilder().getTemplate(type: .bottom)
            .with(color: Color.pink)
            .with(cornerRadius: 15.0)
            .with(blur: 3.0)
            .with(opacity: 0.8)
            .build()
        button.addButtonShadow(shadow: shadow)

        // Add as subview
        tabBarView.addSubview(button)

        // Add button's target
        button.addTarget(self, action: #selector(presentNewScheduledAnimeScreen), for: .touchUpInside)
    }

    func configureConstraints(_ tabBarView: UIView) {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor),
            button.widthAnchor.constraint(equalTo: tabBarView.widthAnchor, multiplier: 0.15),
            button.heightAnchor.constraint(equalTo: tabBarView.heightAnchor, multiplier: 0.7),
            button.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -35),
        ])
    }
}
