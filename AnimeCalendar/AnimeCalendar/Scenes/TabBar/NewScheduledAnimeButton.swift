//
//  NewScheduledAnimeButton.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/05/22.
//

import UIKit

final class NewScheduledAnimeButton {
  private weak var tabBarView: UIView?

  private var containerView: UIView!
  private var button: UIButton!

  init(_ tabBarView: UIView) {
    self.tabBarView = tabBarView
  }
}

extension NewScheduledAnimeButton {
  func configureScheduledAnimeButton() {
    configureButton()
  }
}

private extension NewScheduledAnimeButton {
  func configureButton() {
    guard let tabBarView = self.tabBarView else { return }
    button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false

    let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy)
    let image = UIImage(systemName: "plus", withConfiguration: configuration)!
    button.setImage(image, for: .normal)
    button.backgroundColor = Color.pink
    button.tintColor = Color.white

    let shadow = Shadow(
      radius: 3,
      offset: CGSize(width: -0.5, height: 5),
      opacity: 0.8,
      color: Color.pink)

    button.becomeFirstResponder()
    button.addShadowLayer(shadow: shadow, layerRadius: 15)

    tabBarView.addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor),
      button.widthAnchor.constraint(equalTo: tabBarView.widthAnchor, multiplier: 0.15),
      button.heightAnchor.constraint(equalTo: tabBarView.heightAnchor, multiplier: 0.7),
      button.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -35),
    ])
  }
}
