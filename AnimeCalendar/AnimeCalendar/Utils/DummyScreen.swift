//
//  DummyScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 9/05/22.
//

import UIKit

final class DummyScreen: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Color.cream
        modalPresentationStyle = .formSheet
        configureScreen()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureScreen() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("WOF", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
}
