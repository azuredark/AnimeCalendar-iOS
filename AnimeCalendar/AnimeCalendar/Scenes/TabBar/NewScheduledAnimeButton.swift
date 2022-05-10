//
//  NewScheduledAnimeButton.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/05/22.
//

import UIKit

final class NewScheduledAnimeButton: TabBarButton {
  weak var presentsNewScreenDelegate: PresentsNewScreen?

  internal var button = UIButton(type: .system)
  init() {
    print("INITED: \(self)")
  }
}

extension NewScheduledAnimeButton {
  func createButton(in tabBarView: UITabBar) {
    configureButton(tabBarView)
    configureConstraints(tabBarView)
  }

  // TODO: FIX PRESENTING NewScheduledAnimeScreen
  func configureButtonPresentingView(presents screenToPresent: ScreenProtocol) {
//    guard let newScheduledAnimeScreen = screen as? NewScheduledAnimeScreen else { return }
//    print("Presenting: \(presentsNewScreenDelegate)")
//    presentsNewScreenDelegate?.presentNewScheduledAnime(screen: newScheduledAnimeScreen)
  }

  @objc func presentScreensOnTap() {}
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

    // Button shadow
    let shadow = Shadow(
      radius: 3,
      offset: CGSize(width: -0.5, height: 5),
      opacity: 0.8,
      color: Color.pink)
    button.addShadowLayer(shadow: shadow, layerRadius: 15)

    // Add as subview
    tabBarView.addSubview(button)
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
